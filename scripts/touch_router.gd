extends Node
## Owns touch-button capture and modal filtering; never changes game state.
## World gestures continue to the main scene's _unhandled_input handler.
var buttons: Array[Button] = []
var captures: Dictionary = {}
var modal_provider: Callable

func register_button(control: Button) -> void:
	if buttons.has(control):
		return
	buttons.append(control)
	control.tree_exiting.connect(_unregister_button.bind(control), CONNECT_ONE_SHOT)

func _unregister_button(control: Button) -> void:
	buttons.erase(control)
	var was_held = false
	for index in captures.keys():
		if captures[index] == control:
			captures.erase(index)
			was_held = true
	if is_instance_valid(control) and was_held:
		control.modulate = Color.WHITE
		control.button_up.emit()

func release_all() -> void:
	# Clear ownership before signals; callbacks may close menus recursively.
	var held = captures.values()
	captures.clear()
	var released: Array = []
	for control in held:
		if is_instance_valid(control) and not released.has(control):
			released.append(control)
			control.modulate = Color.WHITE
			control.button_up.emit()

func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag and captures.has(event.index):
		get_viewport().set_input_as_handled()
		return
	if not event is InputEventScreenTouch:
		return
	if not event.pressed:
		if not captures.has(event.index):
			return
		var control: Button = captures[event.index]
		captures.erase(event.index)
		if is_instance_valid(control) and not captures.values().has(control):
			control.modulate = Color.WHITE
			control.button_up.emit()
			if control.is_visible_in_tree() and not control.disabled and control.get_global_rect().has_point(event.position):
				control.pressed.emit()
		get_viewport().set_input_as_handled()
		return
	var modal: Control = modal_provider.call() if modal_provider.is_valid() else null
	for index in range(buttons.size() - 1, -1, -1):
		var control = buttons[index]
		if not is_instance_valid(control) or control.is_queued_for_deletion() or not control.is_visible_in_tree() or control.disabled:
			continue
		if modal != null and not modal.is_ancestor_of(control):
			continue
		if control.get_global_rect().has_point(event.position):
			var already_held = captures.values().has(control)
			captures[event.index] = control
			control.modulate = Color("f1c98b")
			if not already_held:
				control.button_down.emit()
			get_viewport().set_input_as_handled()
			return
	if modal != null:
		get_viewport().set_input_as_handled()
