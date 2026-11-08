extends Node2D
## Presentation and live simulation. Gameplay rules live in Survival.
const Rules = preload("res://scripts/survival.gd")
const Occupancy = preload("res://scripts/world_occupancy.gd")
const Construction = preload("res://scripts/construction_controller.gd")
const TouchRouter = preload("res://scripts/touch_router.gd")
const INK = Color("d8e2d4")
const MUTED = Color("8a9c96")
const GOLD = Color("edbd72")
const GREEN = Color("a0d0a0")
const RED = Color("ed887b")
var state = Rules.new()
var chunks: Dictionary = {}
var enemies: Dictionary = {}
var tracers: Array = []
var camera_pos = Vector2.ZERO
var aim = Vector2.RIGHT
var font: Font
var ui: CanvasLayer
var hud: Label
var objective: Label
var notice_label: Label
var bag_label: Label
var home_panel: PanelContainer
var build_panel: PanelContainer
var pause_panel: PanelContainer
var inventory_panel: PanelContainer
var home_text: Label
var build_text: Label
var menu_open = false
var build_mode = false
var selected = "wall"
var dismantling = false
var paused = false
var touches: Dictionary = {}
var stick_id = -1
var stick_origin = Vector2.ZERO
var stick = Vector2.ZERO
var firing = false
var mouse_firing = false
var shoot_cd = 0.0
var reload_time = 0.0
var extract_time = 0.0
var extract_hold = false
var hit_cd = 0.0
var turret_cd = 0.0
var noise_pos = Vector2.ZERO
var noise_time = 0.0
var save_timer = 0.0
var raid_timer = 0.0
var notice_timer = 0.0
var tick = 0.0
var intro = true
var touch_router: Node
var touch_buttons: Array[Button]:
	get:
		return touch_router.buttons
var modal_backdrop: ColorRect
var ground_texture: Texture2D
var tree_texture: Texture2D

func active_touch_modal() -> Control:
	if paused and is_instance_valid(pause_panel) and pause_panel.visible:
		return pause_panel
	if menu_open:
		return inventory_panel if is_instance_valid(inventory_panel) and inventory_panel.visible else home_panel
	return null

func _ready() -> void:
	get_tree().auto_accept_quit = false
	font = load("res://assets/NotoSansCJKsc-Regular.otf") if ResourceLoader.exists("res://assets/NotoSansCJKsc-Regular.otf") else ThemeDB.fallback_font
	if ResourceLoader.exists("res://assets/forest-ground-v2.png"):
		ground_texture = load("res://assets/forest-ground-v2.png")
	if ResourceLoader.exists("res://assets/spruce-v2.png"):
		tree_texture = load("res://assets/spruce-v2.png")
	state.load_game()
	camera_pos = state.position
	touch_router = TouchRouter.new()
	touch_router.modal_provider = active_touch_modal
	add_child(touch_router)
	setup_ui()
	refresh_chunks()
	if state.raid_active:
		start_raid(true)
	open_home()
	paused = false
	pause_panel.visible = false
	if state.load_notice != "":
		notify(state.load_notice, 12)
	elif intro:
		notify("欢迎来到余烬营地。先在营地整备，再向外探索。", 7)
	set_process(true)

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		state.save_game()
		get_tree().quit()
	if what == NOTIFICATION_APPLICATION_PAUSED or what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		state.save_game()
		paused = true
		if is_instance_valid(pause_panel):
			pause_panel.visible = true
		clear_input()

func _process(delta: float) -> void:
	var dt = minf(delta, 0.05)
	tick += dt
	if not paused and not menu_open:
		update_player(dt)
		update_enemies(dt)
		update_turrets(dt)
		update_survival(dt)
		update_extract(dt)
		refresh_chunks()
		camera_pos = camera_pos.lerp(state.position, 1 - exp(-12 * dt))
		for tracer in tracers:
			tracer.life -= dt
		tracers = tracers.filter(func(tracer): return tracer.life > 0)
		if state.hp <= 0:
			state.die()
			extract_time = 0
			clear_input()
			state.save_game()
			notify("负伤返回营地：背包物资和随身弹药丢失。营地仍然保留。", 8)
			open_home()
		if float(state.structures[state.core_key()].hp) <= 0:
			state.structures[state.core_key()].hp = 300
			state.raid_active = false
			state.threat = 0
			for item in state.stash:
				state.stash[item] = floori(int(state.stash[item]) * 0.7)
			enemies.clear()
			state.position = state.camp_origin() + Vector2(0, 130)
			state.outside = false
			state.save_game()
			notify("营地被突破：仓库损失 30%，核心已应急修复。", 8)
			open_home()
		if state.raid_active:
			raid_timer += dt
			var remaining = 0
			for enemy in enemies.values():
				if enemy.get("raid", false):
					remaining += 1
			if remaining == 0 and raid_timer > 2:
				state.raid_active = false
				state.threat = 10
				state.stash.scrap += 4
				state.stash.ammo += 2
				state.save_game()
				notify("守住了！回收废金属 4、弹药包 2。", 6)
		elif state.threat >= 100 and state.in_camp(state.position):
			start_raid()
	save_timer += dt
	if save_timer > 15:
		save_timer = 0
		state.save_game()
	notice_timer -= dt
	notice_label.visible = notice_timer > 0
	update_hud()
	modal_backdrop.visible = menu_open or paused
	queue_redraw()

func update_player(dt: float) -> void:
	var direction = Vector2(float(Input.is_physical_key_pressed(KEY_D)) - float(Input.is_physical_key_pressed(KEY_A)), float(Input.is_physical_key_pressed(KEY_S)) - float(Input.is_physical_key_pressed(KEY_W)))
	if stick.length() > 0.1:
		direction = stick
	direction = direction.limit_length()
	var sprinting = Input.is_physical_key_pressed(KEY_SHIFT) and state.stamina > 2 and direction.length() > 0.1
	var speed = 180.0 * (0.7 if state.weight() > 18 else 1.0)
	if sprinting:
		speed *= 1.55
		state.stamina = maxf(0, state.stamina - dt * 20)
		noise_pos = state.position
		noise_time = 0.4
	else:
		state.stamina = minf(100, state.stamina + dt * 13)
	state.position = move_actor(state.position, direction * speed * dt, 16)
	if direction.length() > 0.1 and not (mouse_firing or firing):
		aim = direction.normalized()
	if state.position.distance_to(state.camp_origin()) > 280:
		state.outside = true
	shoot_cd = maxf(0, shoot_cd - dt)
	hit_cd = maxf(0, hit_cd - dt)
	noise_time = maxf(0, noise_time - dt)
	if reload_time > 0:
		reload_time -= dt
		if reload_time <= 0:
			state.reload_weapon()
	if firing:
		var nearest = nearest_enemy(state.position, 490)
		if nearest != "":
			aim = (enemies[nearest].pos - state.position).normalized()
	if (firing or mouse_firing) and shoot_cd <= 0 and reload_time <= 0:
		shoot()

func shoot() -> void:
	shoot_cd = 0.26
	if state.magazine <= 0:
		request_reload()
		return
	state.magazine -= 1
	noise_pos = state.position
	noise_time = 2.0
	state.threat = minf(110, state.threat + 0.5)
	var end = state.position + aim * 580
	var best = ""
	var distance = 580.0
	for id in enemies:
		var relative: Vector2 = enemies[id].pos - state.position
		var along = relative.dot(aim)
		if along > 0 and along < distance and absf(relative.cross(aim)) < 23:
			best = id
			distance = along
	# Trace through obstacles and structures, preventing shots through walls.
	var steps = ceili(distance / 8)
	var blocked = false
	for index in range(3, steps + 1):
		var point = state.position + aim * index * 8
		if solid_at(point, 1):
			end = point
			blocked = true
			break
	if not blocked and best != "":
		end = enemies[best].pos
		damage_enemy(best, 40)
	tracers.append({"from": state.position + aim * 20, "to": end, "life": 0.09})

func request_reload() -> void:
	if reload_time <= 0 and state.magazine < 12 and state.reserve > 0:
		reload_time = 1.7
	elif state.reserve <= 0 and state.magazine == 0:
		notify("没有弹药：可以使用近战，或回营地补给。")

func melee() -> void:
	if paused or menu_open or state.stamina < 20 or shoot_cd > 0:
		return
	state.stamina -= 20
	shoot_cd = 0.55
	var target = nearest_enemy(state.position, 90)
	if target != "":
		aim = (enemies[target].pos - state.position).normalized()
		damage_enemy(target, 55)
	tracers.append({"from": state.position, "to": state.position + aim * 75, "life": 0.18})

func nearest_enemy(pos: Vector2, radius: float) -> String:
	var result = ""
	var best = radius
	for id in enemies:
		var distance = pos.distance_to(enemies[id].pos)
		if distance < best:
			best = distance
			result = id
	return result

func damage_enemy(id: String, damage: float) -> void:
	if not enemies.has(id):
		return
	enemies[id].hp -= damage
	enemies[id].alert = 6.0
	if enemies[id].hp <= 0:
		state.dead[id] = true
		enemies.erase(id)
		state.kills += 1

func move_actor(pos: Vector2, motion: Vector2, radius: float) -> Vector2:
	var result = pos
	if not solid_at(result + Vector2(motion.x, 0), radius):
		result.x += motion.x
	if not solid_at(result + Vector2(0, motion.y), radius):
		result.y += motion.y
	return result

func solid_at(pos: Vector2, radius: float) -> bool:
	return Occupancy.solid_at(state, pos, radius, chunks)

func update_enemies(dt: float) -> void:
	for id in enemies.keys():
		if not enemies.has(id):
			continue
		var enemy = enemies[id]
		enemy.cooldown = maxf(0, enemy.cooldown - dt)
		enemy.alert = maxf(0, enemy.alert - dt)
		var distance = enemy.pos.distance_to(state.position)
		var target: Vector2 = enemy.home + Vector2(sin(tick * 0.4 + enemy.phase), cos(tick * 0.3 + enemy.phase)) * 50
		var active = false
		if enemy.get("raid", false):
			target = state.camp_origin()
			active = true
		if distance < 235 or enemy.alert > 0:
			target = state.position
			active = true
		elif noise_time > 0 and enemy.pos.distance_to(noise_pos) < 730:
			target = noise_pos
			active = true
		var direction: Vector2 = (target - enemy.pos).normalized()
		var speed = [54, 88, 40][int(enemy.kind)] if active else 19
		var next = move_actor(enemy.pos, direction * float(speed) * dt, 15)
		if next.distance_to(enemy.pos) < float(speed) * dt * 0.2:
			# Local steering for small props; attack player-made obstructions.
			next = move_actor(enemy.pos, direction.rotated(1.2) * float(speed) * dt, 15)
			var key = state.cell_key(state.cell_at(enemy.pos + direction * 36))
			if state.structures.has(key) and enemy.cooldown <= 0:
				state.damage_structure(key, 14 if enemy.kind != 2 else 28)
				enemy.cooldown = 1.0
		enemy.pos = next
		if distance < 37 and hit_cd <= 0:
			state.hp -= 10 if enemy.kind != 2 else 18
			state.bleeding = true
			hit_cd = 1.2
			clear_extract()
		for x in range(-1, 2):
			for y in range(-1, 2):
				var key = state.cell_key(state.cell_at(enemy.pos) + Vector2i(x, y))
				if not state.structures.has(key):
					continue
				if state.structures[key].kind == "spikes" and enemy.pos.distance_to(state.cell_position(state.key_cell(key))) < 38:
					damage_enemy(id, dt * 28)
					state.damage_structure(key, dt * 3)
		if enemy.get("raid", false) and enemy.pos.distance_to(state.camp_origin()) < 65 and enemy.cooldown <= 0:
			state.damage_structure(state.core_key(), 18)
			enemy.cooldown = 1.0

func update_turrets(dt: float) -> void:
	turret_cd -= dt
	if turret_cd > 0 or not state.has_kind("generator") or int(state.stash.get("fuel", 0)) <= 0:
		return
	turret_cd = 0.7
	for key in state.structures:
		if state.structures[key].get("camp_id", state.active_camp) != state.active_camp:
			continue
		if state.structures[key].kind != "turret" or (state.turret_rounds <= 0 and int(state.stash.get("ammo", 0)) <= 0):
			continue
		var pos = state.cell_position(state.key_cell(key))
		var target = nearest_enemy(pos, 340)
		if target != "":
			var end: Vector2 = enemies[target].pos
			var blocked = false
			for index in range(5, ceili(pos.distance_to(end) / 8)):
				if solid_at(pos.move_toward(end, index * 8), 1):
					blocked = true
					break
			if blocked:
				continue
			if state.turret_rounds <= 0:
				state.stash.ammo -= 1
				state.turret_rounds = 24
			state.turret_rounds -= 1
			damage_enemy(target, 70)
			tracers.append({"from": pos, "to": end, "life": 0.12})

func update_survival(dt: float) -> void:
	for message in state.update_convoys(dt):
		notify(message, 6)
	state.hunger = maxf(0, state.hunger - dt * 0.06)
	if state.bleeding:
		state.hp -= dt * 0.22
	if state.hunger <= 0:
		state.hp -= dt * 0.3
	if state.has_kind("generator") and int(state.stash.get("fuel", 0)) > 0:
		state.threat = minf(110, state.threat + dt * 0.065)
		# Discrete fuel consumption is tracked by a world clock, no offline drain.
		state.generator_seconds += dt
		if state.generator_seconds >= 120:
			state.generator_seconds -= 120
			state.stash.fuel -= 1
	if Input.is_physical_key_pressed(KEY_E):
		extract_hold = true
	elif not touches.has("extract"):
		extract_hold = false

func update_extract(dt: float) -> void:
	if not extract_hold or not state.in_camp(state.position) or not state.outside or state.raid_active or nearest_enemy(state.position, 180) != "":
		extract_time = 0
		return
	extract_time += dt
	if extract_time >= 4:
		var goods = state.extract()
		clear_extract()
		state.save_game()
		notify("撤离成功，物资已入库：" + describe_items(goods), 7)
		open_home()

func clear_extract() -> void:
	extract_time = 0
	extract_hold = false

func refresh_chunks() -> void:
	var center = Vector2i(floori(state.position.x / Rules.CHUNK), floori(state.position.y / Rules.CHUNK))
	var wanted: Dictionary = {}
	for x in range(-1, 2):
		for y in range(-1, 2):
			var cell = center + Vector2i(x, y)
			var key = state.cell_key(cell)
			wanted[key] = true
			if chunks.has(key):
				continue
			var data = state.chunk_data(cell)
			chunks[key] = data
			for entry in data.zombies:
				if state.dead.has(entry.id) or enemies.has(entry.id):
					continue
				enemies[entry.id] = {"pos": entry.pos, "home": entry.pos, "kind": entry.kind, "hp": 110.0 if entry.kind == 2 else 70.0,
					"phase": float(str(entry.id).hash() % 100), "cooldown": 0.0, "alert": 0.0, "raid": false}
	for key in chunks.keys():
		if not wanted.has(key):
			chunks.erase(key)
	for id in enemies.keys():
		if not enemies[id].get("raid", false) and enemies[id].pos.distance_to(state.position) > 2100:
			enemies.erase(id)

func start_raid(resume: bool = false) -> void:
	if state.raid_active and not resume:
		notify("当前尸潮尚未结束")
		return
	if not resume:
		state.raid_wave += 1
	state.raid_active = true
	raid_timer = 0
	var rng = RandomNumberGenerator.new()
	rng.seed = state.world_seed + state.raid_wave * 97
	for index in range(mini(24, 6 + state.raid_wave * 2)):
		var id = "raid/%d/%d" % [state.raid_wave, index]
		if state.dead.has(id):
			continue
		var pos = state.camp_origin() + Vector2.from_angle(rng.randf() * TAU) * (state.claim_radius() + 230)
		enemies[id] = {"pos": pos, "home": pos, "kind": index % 3, "hp": 110.0 if index % 3 == 2 else 70.0, "phase": 0.0, "cooldown": 0.0, "alert": 0.0, "raid": true}
	state.save_game()
	notify("尸潮来袭！守住营地核心，炮台会消耗仓库弹药。", 8)

func interact() -> void:
	if paused or menu_open:
		return
	for id in state.camps:
		if id != state.active_camp and state.enter_camp(id):
			notify("已抵达" + state.camps[id].name + "；物资存放在当地仓库")
			break
	for key in state.structures:
		if state.structures[key].kind == "gate" and state.cell_position(state.key_cell(key)).distance_to(state.position) < 90:
			var error = Construction.toggle_gate(state, state.key_cell(key), enemies)
			if error != "":
				notify(error)
				return
			state.save_game()
			notify("营地门已打开" if state.structures[key].open else "营地门已关闭")
			return
	if state.in_camp(state.position) and not state.outside and not state.raid_active:
		open_home()
		return
	var best: Dictionary = {}
	var distance = 100.0
	for chunk in chunks.values():
		for entry in chunk.loot:
			if int(state.opened.get(entry.id, 0)) >= int(entry.qty):
				continue
			var d = state.position.distance_to(entry.pos)
			if d < distance:
				distance = d
				best = entry
	if best.is_empty():
		notify("靠近补给箱搜索。返回营地后，按住撤离完成入库。")
		return
	var taken = state.add_loot(best.item, int(best.qty) - int(state.opened.get(best.id, 0)))
	state.opened[best.id] = int(state.opened.get(best.id, 0)) + taken
	state.save_game()
	notify("获得 %s ×%d" % [Rules.ITEMS[best.item].name, taken] if taken > 0 else "背包已满：打开背包丢弃部分物品。")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.physical_keycode:
			KEY_ESCAPE: toggle_pause()
			KEY_F: interact()
			KEY_R: request_reload()
			KEY_H: use_medicine()
			KEY_V: melee()
			KEY_B: toggle_build()
			KEY_TAB: open_inventory()
	if paused or menu_open:
		return
	if event is InputEventMouseMotion and not build_mode:
		aim = (screen_to_world(event.position) - state.position).normalized()
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if build_mode and event.pressed:
			place_at(screen_to_world(event.position))
		else:
			mouse_firing = event.pressed
	if event is InputEventScreenTouch:
		if event.pressed:
			if build_mode:
				place_at(screen_to_world(event.position))
			elif event.position.x < 360 and event.position.y > 330 and stick_id == -1:
				stick_id = event.index
				stick_origin = event.position
				touches[event.index] = true
		else:
			touches.erase(event.index)
			if event.index == stick_id:
				stick_id = -1
				stick = Vector2.ZERO
	if event is InputEventScreenDrag and event.index == stick_id:
		stick = ((event.position - stick_origin) / 65).limit_length()

func place_at(pos: Vector2) -> void:
	var cell = state.cell_at(pos)
	var result = Construction.dismantle(state, cell) if dismantling else Construction.build(state, selected, cell, chunks, enemies)
	if result != "":
		notify(result)
	else:
		state.save_game()
		notify("已拆除，返还一半材料" if dismantling else "已建造：" + Rules.BLUEPRINTS[selected].name)
	update_build_text()

func clear_input() -> void:
	if is_instance_valid(touch_router):
		touch_router.release_all()
	touches.clear()
	stick = Vector2.ZERO
	stick_id = -1
	firing = false
	mouse_firing = false
	clear_extract()

func screen_to_world(pos: Vector2) -> Vector2:
	return pos + camera_pos - Vector2(640, 360)

func screen(pos: Vector2) -> Vector2:
	return pos - camera_pos + Vector2(640, 360)

func notify(message: String, seconds: float = 4.0) -> void:
	notice_timer = seconds
	if is_instance_valid(notice_label):
		notice_label.text = message

func describe_items(items: Dictionary) -> String:
	var parts = PackedStringArray()
	for item in items:
		if int(items[item]) > 0:
			parts.append("%s %d" % [Rules.ITEMS[item].name, int(items[item])])
	return "  ·  ".join(parts) if parts.size() > 0 else "无"

func make_label(text: String, size: int = 18, color: Color = INK) -> Label:
	var label = Label.new()
	label.text = text
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_font_override("font", font)
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", color)
	return label

func style_box(color: Color, border: Color = Color("3b514e")) -> StyleBoxFlat:
	var box = StyleBoxFlat.new()
	box.bg_color = color
	box.border_color = border
	box.set_border_width_all(1)
	box.set_corner_radius_all(8)
	box.shadow_color = Color(0, 0, 0, 0.28)
	box.shadow_size = 5
	box.shadow_offset = Vector2(0, 4)
	box.content_margin_left = 18
	box.content_margin_right = 18
	box.content_margin_top = 12
	box.content_margin_bottom = 12
	return box

func button(text: String, callback: Callable, parent: Node, width: float = 110) -> Button:
	var control = Button.new()
	control.text = text
	control.custom_minimum_size = Vector2(width, 58)
	control.add_theme_font_override("font", font)
	control.add_theme_font_size_override("font_size", 19)
	control.add_theme_color_override("font_color", INK)
	control.add_theme_stylebox_override("normal", style_box(Color("182c2a")))
	control.add_theme_stylebox_override("hover", style_box(Color("29413a"), GOLD))
	control.add_theme_stylebox_override("pressed", style_box(Color("465644"), GOLD))
	control.pressed.connect(callback)
	control.focus_mode = Control.FOCUS_NONE
	touch_router.register_button(control)
	parent.add_child(control)
	return control

func panel_at(rect: Rect2) -> PanelContainer:
	var panel = PanelContainer.new()
	panel.position = rect.position
	panel.size = rect.size
	panel.add_theme_stylebox_override("panel", style_box(Color("101f20")))
	ui.add_child(panel)
	return panel

func stack(parent: Node) -> VBoxContainer:
	var box = VBoxContainer.new()
	box.add_theme_constant_override("separation", 10)
	parent.add_child(box)
	return box

func setup_ui() -> void:
	ui = CanvasLayer.new()
	add_child(ui)
	var top = panel_at(Rect2(20, 16, 1240, 78))
	top.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var row = HBoxContainer.new()
	row.add_theme_constant_override("separation", 30)
	top.add_child(row)
	row.add_child(make_label("余烬营地", 27, GOLD))
	hud = make_label("", 17)
	row.add_child(hud)
	objective = make_label("", 19, GREEN)
	objective.position = Vector2(30, 112)
	ui.add_child(objective)
	bag_label = make_label("", 15, MUTED)
	bag_label.position = Vector2(30, 145)
	ui.add_child(bag_label)
	notice_label = make_label("", 18, GOLD)
	notice_label.position = Vector2(225, 620)
	notice_label.size = Vector2(820, 75)
	notice_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	ui.add_child(notice_label)
	var tools = HBoxContainer.new()
	tools.position = Vector2(655, 111)
	ui.add_child(tools)
	button("背包", open_inventory, tools, 80)
	button("建造", toggle_build, tools, 80)
	button("药品", use_medicine, tools, 80)
	button("进食", eat_food, tools, 80)
	button("扎营", settle_here, tools, 80)
	button("营地", open_logistics, tools, 80)
	button("暂停", toggle_pause, tools, 80)
	var actions = HBoxContainer.new()
	actions.position = Vector2(760, 550)
	ui.add_child(actions)
	button("搜索 / 营地", interact, actions, 125)
	button("换弹", request_reload, actions, 90)
	button("近战", melee, actions, 90)
	var fire = button("开火", func(): pass, actions, 95)
	fire.button_down.connect(func(): firing = true)
	fire.button_up.connect(func(): firing = false)
	var exit_row = HBoxContainer.new()
	exit_row.position = Vector2(930, 620)
	ui.add_child(exit_row)
	var exit_button = button("按住撤离 · 4 秒", func(): pass, exit_row, 210)
	exit_button.button_down.connect(func(): touches["extract"] = true; extract_hold = true)
	exit_button.button_up.connect(func(): touches.erase("extract"); clear_extract())
	modal_backdrop = ColorRect.new()
	modal_backdrop.color = Color(0.015, 0.025, 0.028, 0.76)
	modal_backdrop.position = Vector2.ZERO
	modal_backdrop.size = Vector2(1280, 720)
	modal_backdrop.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui.add_child(modal_backdrop)
	setup_home()
	setup_build()
	pause_panel = panel_at(Rect2(400, 220, 480, 260))
	var pause_box = stack(pause_panel)
	pause_box.add_child(make_label("已暂停 · 离线不会被袭击", 23, GOLD))
	button("继续游戏", toggle_pause, pause_box)
	button("保存游戏", func(): notify("保存成功" if state.save_game() else state.save_error), pause_box)
	pause_panel.visible = false
	inventory_panel = panel_at(Rect2(330, 175, 620, 485))
	inventory_panel.visible = false

func setup_home() -> void:
	home_panel = panel_at(Rect2(115, 65, 1050, 590))
	var box = stack(home_panel)
	var header = HBoxContainer.new()
	header.add_theme_constant_override("separation", 22)
	box.add_child(header)
	header.add_child(make_label("余烬营地", 36, GOLD))
	header.add_child(make_label("EMBER CAMP  /  营地行动中心", 17, MUTED))
	var line = HSeparator.new()
	box.add_child(line)
	var columns = HBoxContainer.new()
	columns.add_theme_constant_override("separation", 34)
	box.add_child(columns)
	var left = stack(columns)
	left.add_theme_constant_override("separation", 6)
	left.custom_minimum_size.x = 345
	left.add_child(make_label("荒野之外，留一盏灯。", 25, INK))
	left.add_child(make_label("搜寻物资，选择营址。\n守住防线，让营地继续生长。", 19, MUTED))
	var enter = button("出发 · 进入大世界", close_home, left, 345)
	enter.custom_minimum_size.y = 70
	enter.add_theme_stylebox_override("normal", style_box(Color("bd945c"), Color("e4bd80")))
	enter.add_theme_color_override("font_color", Color("15221e"))
	button("建设营地与布置防线", func(): close_home(); toggle_build(), left, 345)
	left.add_child(make_label("触屏操作", 20, GOLD))
	left.add_child(make_label("左下拖动：移动\n右下按住开火：自动瞄准\n靠近补给箱：点击搜索\n回营后按住撤离：物资入库", 19, INK))
	var right = stack(columns)
	right.add_theme_constant_override("separation", 6)
	right.custom_minimum_size.x = 625
	right.add_child(make_label("整备与补给", 23, GOLD))
	home_text = make_label("", 17)
	home_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	home_text.custom_minimum_size = Vector2(625, 133)
	right.add_child(home_text)
	var grid = GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 10)
	grid.add_theme_constant_override("v_separation", 10)
	right.add_child(grid)
	button("弹药补给", func(): notify("补充 24 发" if state.resupply() else "弹药包不足或备弹已充足"); refresh_home(), grid, 250)
	button("治疗与止血", func(): use_medicine(); refresh_home(), grid, 250)
	button("进食", func(): eat_food(); refresh_home(), grid, 250)
	button("修复营地", func(): var error = state.repair_all(); notify("设施已修复" if error == "" else error); refresh_home(), grid, 250)
	var row = HBoxContainer.new()
	right.add_child(row)
	button("休息至次日", rest_day, row, 250)
	button("布防演练", func(): close_home(); start_raid(), row, 250)
	button("装载前哨建营包 · 18.4 kg", func(): var error = state.load_building_kit(); notify("建营物资已装入背包，前往远处扎营" if error == "" else error); refresh_home(), right, 510)
	box.add_child(make_label("先探索，再扎营  /  首次建造或撤离入库将锁定营址  /  离线时营地不会遭到攻击", 16, MUTED))

func refresh_home() -> void:
	var stock_a = {"wood": state.stash.get("wood", 0), "scrap": state.stash.get("scrap", 0), "cloth": state.stash.get("cloth", 0), "food": state.stash.get("food", 0)}
	var stock_b = {"med": state.stash.get("med", 0), "ammo": state.stash.get("ammo", 0), "fuel": state.stash.get("fuel", 0)}
	home_text.text = "第 %d 天  ·  %s\n%s\n%s\n核心 %d / 600  ·  设施 %d  ·  领地 %d\n炮台：1 弹药包 / 24 发    发电机：1 燃料 / 120 秒" % [state.day, state.camps[state.active_camp].name, describe_items(stock_a), describe_items(stock_b), state.structures[state.core_key()].hp, state.structures.size(), state.claim_radius()]

	state.save_game()

func open_home() -> void:
	menu_open = true
	build_mode = false
	clear_input()
	home_panel.visible = true
	build_panel.visible = false
	refresh_home()

func close_home() -> void:
	menu_open = false
	home_panel.visible = false
	state.save_game()

func rest_day() -> void:
	if state.raid_active:
		notify("尸潮期间无法休息")
		return
	if not state.spend({"food": 1}):
		notify("休息需要罐头 1")
		return
	state.day += 1
	state.hp = minf(100, state.hp + 25)
	state.hunger = 100
	state.stamina = 100
	# Loot is finite; a new day replenishes roaming zombies, not containers.
	for id in state.dead.keys():
		if not str(id).begins_with("raid/"):
			state.dead.erase(id)
	enemies.clear()
	chunks.clear()
	refresh_chunks()
	refresh_home()
	notify("天亮了，游荡感染者再次出现。已搜刮的容器不会刷新。")

func setup_build() -> void:
	build_panel = panel_at(Rect2(955, 175, 305, 365))
	var box = stack(build_panel)
	box.add_child(make_label("营地施工", 23, GOLD))
	var grid = GridContainer.new()
	grid.columns = 2
	box.add_child(grid)
	for kind in Rules.BLUEPRINTS:
		var choice = str(kind)
		button(Rules.BLUEPRINTS[kind].name, func(): selected = choice; dismantling = false; update_build_text(), grid, 125)
	build_text = make_label("", 14, MUTED)
	box.add_child(build_text)
	button("拆除模式 / 返还 50%", func(): dismantling = true; update_build_text(), box)
	build_panel.visible = false
	update_build_text()

func update_build_text() -> void:
	build_text.text = "点击世界格子拆除" if dismantling else "%s：%s\n点击世界格子放置；再次点建造退出" % [Rules.BLUEPRINTS[selected].name, describe_items(Rules.BLUEPRINTS[selected].cost)]

func toggle_build() -> void:
	if menu_open or paused:
		return
	if state.position.distance_to(state.camp_origin()) > state.claim_radius() + 120:
		notify("返回领地附近进行建造")
		return
	build_mode = not build_mode
	build_panel.visible = build_mode
	clear_input()
	if build_mode:
		notify("施工期间世界继续运行。绿色范围为可建设领地。")

func use_medicine() -> void:
	if paused:
		return
	notify("已治疗并止血" if state.heal() else "没有药品，或无需治疗")
	state.save_game()

func eat_food() -> void:
	if paused:
		return
	notify("已进食" if state.eat() else "没有罐头，或无需进食")
	state.save_game()

func toggle_pause() -> void:
	paused = not paused
	pause_panel.visible = paused
	clear_input()
	state.save_game()

func open_inventory() -> void:
	if inventory_panel.visible:
		inventory_panel.visible = false
		menu_open = home_panel.visible
		return
	if menu_open or paused:
		return
	clear_input()
	menu_open = true
	for child in inventory_panel.get_children():
		inventory_panel.remove_child(child)
		child.queue_free()
	var box = stack(inventory_panel)
	box.add_child(make_label("随身背包  %.1f / 24 kg" % state.weight(), 24, GOLD))
	for item in Rules.ITEMS:
		if int(state.bag.get(item, 0)) <= 0:
			continue
		var item_id = str(item)
		button("%s ×%d    丢弃 1" % [Rules.ITEMS[item].name, state.bag[item]], func(): state.bag[item_id] -= 1; state.save_game(); inventory_panel.visible = false; menu_open = false; open_inventory(), box)
	button("关闭背包", open_inventory, box)
	inventory_panel.visible = true

func update_hud() -> void:
	hud.text = "生命 %03d%s   体力 %03d   饱食 %03d     弹匣 %02d / %02d     背包 %.1f / 24 kg" % [maxi(0, int(state.hp)), " 出血" if state.bleeding else "", state.stamina, state.hunger, state.magazine, state.reserve, state.weight()]
	if state.raid_active:
		objective.text = "尸潮 %d · 守住营地核心  %d / 600" % [state.raid_wave, state.structures[state.core_key()].hp]
	elif extract_time > 0:
		objective.text = "正在撤离：%.1f / 4 秒" % extract_time
	elif state.in_camp(state.position) and state.outside:
		objective.text = "已返回营地 · 按住撤离，将随身物资入库"
	else:
		objective.text = "第 %d 天  ·  距营地 %d  ·  尸群威胁 %d%%" % [state.day, state.position.distance_to(state.camp_origin()), state.threat]
	bag_label.text = "正在换弹…" if reload_time > 0 else ("施工中 · 仓库材料直接用于营地扩建" if build_mode else "随身：" + describe_items(state.bag))
	if state.save_error != "":
		bag_label.text = state.save_error

func _draw() -> void:
	var view = Rect2(camera_pos - Vector2(700, 420), Vector2(1400, 840))
	var start = Vector2i(floori(view.position.x / 64), floori(view.position.y / 64))
	# Painterly terrain is tiled in world coordinates to avoid texture swimming.
	if ground_texture != null:
		var tile_start = Vector2i(floori(view.position.x / 512), floori(view.position.y / 512))
		for x in range(4):
			for y in range(3):
				draw_texture_rect(ground_texture, Rect2(screen(Vector2(tile_start + Vector2i(x, y)) * 512), Vector2(513, 513)), false, Color(0.65, 0.72, 0.68))
	else:
		draw_rect(Rect2(Vector2.ZERO, Vector2(1280, 720)), Color("293b32"))
	# Roads give generated space a recognizable traversal network.
	for key in chunks:
		var origin = Vector2(state.key_cell(key)) * Rules.CHUNK
		draw_rect(Rect2(screen(origin + Vector2(340, 0)), Vector2(85, Rules.CHUNK)), Color("263231"))
		draw_rect(Rect2(screen(origin + Vector2(0, 340)), Vector2(Rules.CHUNK, 85)), Color("263231"))
		for obstacle in chunks[key].obstacles:
			if not view.has_point(obstacle.pos):
				continue
			var pos = screen(obstacle.pos)
			draw_ellipse_shadow(pos, 25)
			if int(obstacle.type) == 1:
				draw_rect(Rect2(pos - obstacle.size / 2, obstacle.size), Color("56625d"))
				draw_rect(Rect2(pos - obstacle.size / 2 + Vector2(5, 5), obstacle.size - Vector2(10, 10)), Color("374841"))
			else:
				if tree_texture != null:
					draw_circle(pos + Vector2(12, 18), 44, Color(0, 0, 0, 0.15))
					var tint = Color(0.8, 0.91, 0.83) if int(obstacle.type) == 0 else Color(0.93, 0.87, 0.72)
					draw_texture_rect(tree_texture, Rect2(pos - Vector2(55, 63), Vector2(110, 126)), false, tint)
				else:
					draw_circle(pos, 24, Color("405547"))

		for entry in chunks[key].loot:
			if int(state.opened.get(entry.id, 0)) >= int(entry.qty) or not view.has_point(entry.pos):
				continue
			var pos = screen(entry.pos)
			draw_circle(pos, 28 + sin(tick * 2) * 2, Color(0.8, 0.68, 0.35, 0.08))
			draw_rect(Rect2(pos - Vector2(15, 11), Vector2(30, 22)), Color("877a51"))
			draw_rect(Rect2(pos - Vector2(15, 11), Vector2(30, 22)), GOLD, false, 2)
			draw_line(pos - Vector2(0, 10), pos + Vector2(0, 10), GOLD, 3)
			if entry.pos.distance_to(state.position) < 100:
				draw_string(font, pos + Vector2(-38, -30), "搜索补给", HORIZONTAL_ALIGNMENT_LEFT, -1, 17, GOLD)
	var core = screen(state.camp_origin())
	if build_mode:
		draw_arc(core, state.claim_radius(), 0, TAU, 96, Color(0.65, 0.8, 0.55, 0.3), 2)
	draw_arc(core, 200, 0, TAU, 72, Color(0.65, 0.8, 0.55, 0.25), 2)
	if build_mode:
		for x in range(23):
			for y in range(15):
				var cell = start + Vector2i(x, y)
				if state.cell_position(cell).distance_to(state.camp_origin()) <= state.claim_radius():
					draw_rect(Rect2(screen(state.cell_position(cell) - Vector2(32, 32)), Vector2(64, 64)), Color(0.65, 0.85, 0.6, 0.16), false)
	for key in state.structures:
		var structure = state.structures[key]
		var pos = screen(state.cell_position(state.key_cell(key)))
		if pos.x < -100 or pos.x > 1380 or pos.y < -100 or pos.y > 820:
			continue
		var kind: String = structure.kind
		var color = Color("acb293")
		match kind:
			"core": color = GOLD
			"wall", "gate": color = Color("9c8967")
			"spikes": color = Color("b28d74")
			"generator": color = Color("d6a16a")
			"turret": color = Color("8fb5b0")
			"beacon": color = Color("a7c890")
		draw_ellipse_shadow(pos, 30)
		draw_rect(Rect2(pos - Vector2(26, 26), Vector2(52, 52)), Color("283e39"))
		draw_rect(Rect2(pos - Vector2(26, 26), Vector2(52, 52)), color, false, 2)
		if kind == "core":
			# Gentle concentric amber light keeps the refuge readable in the forest.
			for glow in range(5, 0, -1):
				draw_circle(pos, 16 + glow * 14, Color(0.95, 0.59, 0.22, 0.025))
			draw_colored_polygon(PackedVector2Array([pos + Vector2(-25, 20), pos + Vector2(0, -23), pos + Vector2(25, 20)]), Color("bd9b65"))
			draw_colored_polygon(PackedVector2Array([pos + Vector2(-7, 20), pos + Vector2(0, -4), pos + Vector2(8, 20)]), Color("3b342a"))
			draw_circle(pos + Vector2(0, 27), 6, GOLD)
			draw_line(pos + Vector2(-20, 18), pos + Vector2(20, 18), GOLD, 3)
		elif kind == "turret":
			draw_circle(pos, 13, color)
			draw_line(pos, pos + Vector2(30, -10), color, 6)
		elif kind == "spikes":
			for offset in [-16, 0, 16]:
				draw_line(pos + Vector2(offset - 8, 15), pos + Vector2(offset, -15), color, 4)
		else:
			draw_line(pos + Vector2(-18, -13), pos + Vector2(18, 13), color, 3)
		var name_text: String = "营地核心" if kind == "core" else Rules.BLUEPRINTS[kind].name
		draw_string(font, pos + Vector2(-27, -36), name_text, HORIZONTAL_ALIGNMENT_LEFT, -1, 14, color)
		var maximum = 600.0 if kind == "core" else float(Rules.BLUEPRINTS[kind].hp)
		draw_line(pos + Vector2(-25, 33), pos + Vector2(-25 + 50 * float(structure.hp) / maximum, 33), GREEN, 3)
	for enemy in enemies.values():
		if not view.has_point(enemy.pos):
			continue
		var pos = screen(enemy.pos)
		var color: Color = [Color("9bb381"), Color("bd9a78"), Color("799b91")][int(enemy.kind)]
		draw_ellipse_shadow(pos, 16)
		draw_line(pos, pos + Vector2(-13, 12).rotated(enemy.phase), color.darkened(0.2), 7)
		draw_circle(pos, 18 if enemy.kind == 2 else 13, color)
		draw_circle(pos + Vector2(-4, -3), 2, Color("493b32"))
		draw_circle(pos + Vector2(4, -3), 2, RED)
	var player = screen(state.position)
	draw_ellipse_shadow(player, 20)
	draw_line(player - aim * 8, player + aim * 27, Color("202b2d"), 9)
	draw_circle(player, 15, Color("d4d7bd") if hit_cd < 0.8 else RED)
	draw_circle(player - aim * 3, 10, Color("637f7a"))
	draw_line(player + aim * 10, player + aim * 32, GOLD, 5)
	for tracer in tracers:
		draw_line(screen(tracer.from), screen(tracer.to), Color(1, 0.84, 0.5, minf(1, tracer.life * 9)), 2)
	if not state.in_camp(state.position):
		var heading = (state.camp_origin() - state.position).normalized()
		var arrow = player + heading * 110
		draw_line(arrow, arrow - heading.rotated(0.5) * 16, GOLD, 3)
		draw_line(arrow, arrow - heading.rotated(-0.5) * 16, GOLD, 3)
		draw_string(font, arrow + Vector2(12, 0), "营地", HORIZONTAL_ALIGNMENT_LEFT, -1, 16, GOLD)
	# Touch joystick remains visible to communicate the mobile controls.
	var base = stick_origin if stick_id != -1 else Vector2(130, 570)
	draw_circle(base, 68, Color(0.8, 0.9, 0.8, 0.05))
	draw_arc(base, 68, 0, TAU, 48, Color(0.8, 0.9, 0.8, 0.18), 2)
	draw_circle(base + stick * 48, 25, Color(0.8, 0.9, 0.8, 0.2))
	if extract_time > 0:
		draw_arc(player, 45, -PI / 2, -PI / 2 + TAU * extract_time / 4, 48, GREEN, 5)

func draw_ellipse_shadow(pos: Vector2, radius: float) -> void:
	draw_circle(pos + Vector2(4, 8), radius, Color(0, 0, 0, 0.18))

func settle_here() -> void:
	if paused or menu_open or build_mode:
		return
	var cell = state.cell_at(state.position + aim * 128)
	var error = Construction.settle(state, cell, chunks, enemies)
	if error != "":
		notify(error)
		return
	state.save_game()
	notify("已在此扎营！前哨独立仓储，记得留出运费和防御材料。", 7)

func open_logistics() -> void:
	if menu_open or paused:
		return
	clear_input()
	menu_open = true
	for child in inventory_panel.get_children():
		inventory_panel.remove_child(child)
		child.queue_free()
	var scroll = ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(580, 445)
	inventory_panel.add_child(scroll)
	var box = stack(scroll)
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.add_child(make_label("营地网络 · 独立仓储", 24, GOLD))
	box.add_child(make_label("当前：" + state.camps[state.active_camp].name, 18, GREEN))
	for id in state.camps:
		var camp_id = str(id)
		var camp = state.camps[id]
		var text = make_label("%s  (%d, %d)\n%s" % [camp.name, camp.cell[0], camp.cell[1], describe_items(camp.stock)], 15, MUTED)
		text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		text.custom_minimum_size = Vector2(550, 55)
		box.add_child(text)
		if id != state.active_camp and state.in_camp(state.position) and not state.outside:
			button("向%s运输 木材4 / 废金属2 / 罐头1" % camp.name, func(): var error = state.dispatch_convoy(camp_id, {"wood": 4, "scrap": 2, "food": 1}); notify("运输队已出发；暂停与离线不推进运输" if error == "" else error); state.save_game(); inventory_panel.visible = false; menu_open = false; open_logistics(), box)
	for convoy in state.convoys:
		box.add_child(make_label("至%s · 剩余%d秒 · 遇袭风险%d%%" % [state.camps[convoy.target].name, convoy.seconds, convoy.risk * 100], 15, GOLD))
	box.add_child(make_label("运费：燃料1 / 罐头1 / 护卫弹药包1\n每座营地独立库存；抵达核心附近点搜索切换当地管理。", 14, MUTED))
	button("返回世界", func(): inventory_panel.visible = false; menu_open = false, box)
	inventory_panel.visible = true

