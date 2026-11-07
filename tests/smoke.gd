extends SceneTree

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var scene = load("res://scenes/main.tscn").instantiate()
	root.add_child(scene)
	await process_frame
	scene.state = preload("res://scripts/survival.gd").new()
	scene.enemies.clear()
	scene.chunks.clear()
	scene.refresh_chunks()
	scene.close_home()
	scene.paused = false
	scene.state.position = Vector2(900, 900)
	scene.refresh_chunks()
	assert(scene.chunks.size() == 9, "active chunks bounded")
	scene.state.add_loot("wood", 4)
	scene.state.outside = true
	scene.state.position = Vector2(0, 130)
	scene.enemies.clear()
	scene.extract_hold = true
	scene.update_extract(4.1)
	assert(scene.state.bag.is_empty() and scene.state.stash.wood == 28)
	scene.close_home()
	scene.start_raid()
	assert(scene.enemies.size() == 8 and scene.state.raid_active)
	for index in range(90):
		scene.update_enemies(0.05)
	assert(scene.state.structures.has("0,0"))
	print("SCENE SMOKE: chunks, extraction, raid simulation passed")
	scene.queue_free()
	await process_frame
	quit()
