extends SceneTree
var scene
var checks = 0
var failed = 0
func _initialize():
 call_deferred("run")
func check(value: bool, message: String):
 checks += 1
 if not value:
  failed += 1
  push_error(message)
func find_button(text: String) -> Button:
 for index in range(scene.touch_buttons.size() - 1, -1, -1):
  var button = scene.touch_buttons[index]
  if is_instance_valid(button) and button.is_visible_in_tree() and button.text == text:
   return button
 return null
func touch(index: int, pos: Vector2, pressed: bool):
 var event = InputEventScreenTouch.new()
 event.index = index
 event.position = pos
 event.pressed = pressed
 root.push_input(event, true)
func tap(button: Button, index: int = 0):
 var pos = button.get_global_rect().get_center()
 touch(index, pos, true)
 touch(index, pos, false)
func run():
 root.size = Vector2i(1280, 720)
 scene = load("res://scenes/main.tscn").instantiate()
 root.add_child(scene)
 await process_frame
 scene.state = preload("res://scripts/survival.gd").new()
 scene.paused = false
 scene.pause_panel.visible = false
 scene.set_process(false)
 scene.open_home()
 for i in range(4):
  await process_frame
 var enter = find_button("出发 · 进入大世界")
 check(enter != null, "entry button exists")
 var view = Rect2(Vector2.ZERO, root.size)
 for button in scene.touch_buttons:
  if is_instance_valid(button) and button.is_visible_in_tree() and scene.home_panel.is_ancestor_of(button):
   check(view.encloses(button.get_global_rect()), "home button fits viewport: " + button.text + str(button.get_global_rect()))
 check(not scene.home_text.text.contains("WASD"), "phone instructions")
 tap(enter)
 check(not scene.menu_open and not scene.home_panel.visible, "touch enters world")
 var fire = find_button("开火")
 touch(0, Vector2(130,570), true)
 check(scene.stick_id == 0, "first finger moves")
 touch(1, fire.get_global_rect().get_center(), true)
 check(scene.firing and scene.stick_id == 0, "second finger fires without stealing move")
 touch(1, fire.get_global_rect().get_center(), false)
 check(not scene.firing and scene.stick_id == 0, "fire release preserves move")
 touch(0, Vector2(130,570), false)
 check(scene.stick_id == -1, "movement release")
 var exit = find_button("按住撤离 · 4 秒")
 touch(2, exit.get_global_rect().get_center(), true)
 check(scene.extract_hold, "native hold extraction starts")
 touch(2, exit.get_global_rect().get_center(), false)
 check(not scene.extract_hold, "native hold extraction ends")
 tap(find_button("暂停"))
 await process_frame
 await process_frame
 check(scene.paused and scene.pause_panel.visible, "touch pauses")
 var hp = scene.state.hp
 tap(find_button("药品"))
 check(scene.paused and scene.state.hp == hp, "modal prevents underlying interaction")
 tap(find_button("继续游戏"))
 await process_frame
 check(not scene.paused, "touch resumes")
 scene.open_home()
 await process_frame
 var food = find_button("进食")
 scene.state.hunger = 20
 var old_food = int(scene.state.stash.food)
 tap(food)
 check(int(scene.state.stash.food) == old_food - 1, "touch action executes exactly once")
 scene.close_home()
 tap(find_button("背包"))
 await process_frame
 check(scene.inventory_panel.visible, "touch opens inventory")
 tap(find_button("关闭背包"))
 check(not scene.menu_open, "touch closes inventory")
 scene.open_home()
 await process_frame
 enter = find_button("出发 · 进入大世界")
 touch(3,enter.get_global_rect().get_center(),true)
 touch(3,Vector2(1,1),false)
 check(scene.menu_open, "dragged-out release cancels button")
 scene.queue_free()
 await process_frame
 print("TOUCH CHECKS: %d passed, %d failed" % [checks - failed, failed])
 quit(0 if failed == 0 else 1)
