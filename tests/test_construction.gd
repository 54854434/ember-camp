extends SceneTree
const Rules = preload("res://scripts/survival.gd")
const Occupancy = preload("res://scripts/world_occupancy.gd")
const Construction = preload("res://scripts/construction_controller.gd")
var checks = 0
var failures = 0

func check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		push_error(label)

func unchanged(state, before: String, label: String) -> void:
	check(JSON.stringify(state.snapshot()) == before, label + " preserves assets and world")

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var state = Rules.new()
	var cell = Vector2i(2, 0)
	var pos: Vector2 = state.cell_position(cell)
	var clear = {"0,0": {"obstacles": []}, "0,-1": {"obstacles": []}}
	var blocked = {"0,0": {"obstacles": [{"pos": pos, "size": Vector2(30, 30)}]}, "0,-1": {"obstacles": []}}
	var before = JSON.stringify(state.snapshot())
	check(Construction.build_error(state, "wall", cell, clear, {}) == "", "valid placement preview")
	unchanged(state, before, "preview")
	check(Construction.build(state, "wall", cell, blocked, {}) != "", "commit rechecks terrain after preview")
	unchanged(state, before, "terrain rejection")
	check(Construction.build(state, "wall", cell, clear, {"z": {"pos": pos}}) != "", "enemy occupancy rejected")
	unchanged(state, before, "enemy rejection")
	check(Construction.build(state, "wall", Vector2i(0, 1), clear, {}) != "", "reserved escape corridor rejected")
	unchanged(state, before, "corridor rejection")
	check(Construction.build(state, "turret", cell, clear, {}) != "", "technology rejected")
	unchanged(state, before, "technology rejection")
	check(Construction.build(state, "wall", cell, clear, {}) == "", "build command succeeds")
	check(state.stash.wood == 21 and state.structures.has("2,0"), "material debit and footprint appear together")
	check(Occupancy.solid_at(state, pos, 18, clear), "new wall immediately blocks movement")
	before = JSON.stringify(state.snapshot())
	check(Construction.build(state, "wall", cell, clear, {}) != "", "duplicate command rejected")
	unchanged(state, before, "duplicate command")
	check(Construction.dismantle(state, cell) == "", "dismantle command")
	check(state.stash.wood == 22 and not Occupancy.solid_at(state, pos, 18, clear), "dismantle refunds once and releases collision")
	check(Construction.dismantle(state, cell) != "" and state.stash.wood == 22, "repeat dismantle cannot refund twice")
	check(Construction.build(state, "spikes", cell, clear, {}) == "", "trap placement")
	check(not Occupancy.solid_at(state, pos, 18, clear), "trap is walkable")
	before = JSON.stringify(state.snapshot())
	check(Construction.build(state, "wall", cell, clear, {}) != "", "walkable trap still reserves footprint")
	unchanged(state, before, "trap overlap")
	state.damage_structure("2,0", 1000)
	check(Construction.build(state, "gate", cell, clear, {}) == "", "destroyed trap releases build occupancy")
	check(Occupancy.solid_at(state, pos, 18, clear), "closed gate blocks")
	state.position = pos + Vector2(0, 70)
	check(Construction.toggle_gate(state, cell, {}) == "", "nearby gate opens")
	check(not Occupancy.solid_at(state, pos, 18, clear), "opened gate immediately passes movement and shot query")
	var gate_save = Rules.new()
	check(gate_save.restore(JSON.parse_string(JSON.stringify(state.snapshot()))), "opened gate JSON roundtrip")
	check(not Occupancy.solid_at(gate_save, pos, 18, clear) and Construction.build_error(gate_save, "wall", cell, clear, {}) != "", "restored open gate remains walkable but occupied")
	before = JSON.stringify(state.snapshot())
	check(Construction.build(state, "wall", cell, clear, {}) != "", "open gate still reserves construction footprint")
	unchanged(state, before, "open gate overlap")
	state.position = pos
	check(Construction.toggle_gate(state, cell, {}) != "" and state.structures["2,0"].open, "cannot close on player")
	state.position = pos + Vector2(0, 70)
	check(Construction.toggle_gate(state, cell, {"z": {"pos": pos}}) != "" and state.structures["2,0"].open, "cannot close on enemy")
	check(Construction.toggle_gate(state, cell, {}) == "" and Occupancy.solid_at(state, pos, 18, clear), "clear doorway closes and blocks immediately")
	state.damage_structure("2,0", 1000)
	check(not Occupancy.solid_at(state, pos, 18, clear), "gate destruction releases collision")
	var restored = Rules.new()
	check(restored.restore(state.snapshot()), "construction state survives restore")
	check(not Occupancy.solid_at(restored, pos, 18, clear), "restore cannot leave stale collision")
	var far_cell = Vector2i(6, 0)
	state.position = Vector2(-100, 200)
	before = JSON.stringify(state.snapshot())
	check(Construction.build(state, "wall", far_cell, clear, {}) != "", "physical reach enforced independently of claim")
	unchanged(state, before, "out of reach")
	state.stash.wood = 0
	state.position = Vector2(0, 130)
	check(Construction.build(state, "wall", cell, clear, {}) != "", "insufficient materials cannot create structure")
	check(not state.structures.has("2,0"), "rejected cost leaves no ghost footprint")
	var foreign = Rules.new()
	foreign.structures["2,0"] = {"kind": "wall", "hp": 180, "camp_id": "remote"}
	before = JSON.stringify(foreign.snapshot())
	check(Construction.dismantle(foreign, cell) != "", "foreign camp cannot be dismantled for local materials")
	unchanged(foreign, before, "foreign ownership rejection")
	# Empty/missing streamed chunks must not allow building through generated terrain.
	var terrain_state = Rules.new()
	var generated = terrain_state.chunk_data(Vector2i(-2, 4))
	var obstacle: Dictionary = generated.obstacles[0]
	var terrain_cell: Vector2i = terrain_state.cell_at(obstacle.pos)
	check(Occupancy.placement_error(terrain_state, terrain_cell, {}, {}).contains("天然障碍"), "unloaded terrain queried deterministically")
	var boundary_state = Rules.new()
	boundary_state.position = Vector2(-80, 80)
	var boundary_chunks = {"-1,0": {"obstacles": [{"pos": Vector2(-8, 0), "size": Vector2(30, 30)}]}, "0,0": {"obstacles": []}, "-1,-1": {"obstacles": []}, "0,-1": {"obstacles": []}}
	check(Occupancy.placement_error(boundary_state, Vector2i.ZERO, boundary_chunks, {}, 27, 65, "0,0").contains("天然障碍"), "negative chunk boundary collision")
	var camp = Rules.new()
	camp.position = Vector2(-100, 130)
	var camp_cell = Vector2i(2, 2)
	var camp_pos: Vector2 = camp.cell_position(camp_cell)
	before = JSON.stringify(camp.snapshot())
	check(Construction.settle(camp, camp_cell, clear, {"z": {"pos": camp_pos}}) != "", "camp siting rejects nearby enemies")
	unchanged(camp, before, "initial siting rejection")
	check(Construction.settle(camp, camp_cell, clear, {}) == "", "initial siting uses same command boundary")
	check(not Occupancy.solid_at(camp, Vector2.ZERO, 18, clear) and Occupancy.solid_at(camp, camp_pos, 18, clear), "moving initial core vacates old footprint")
	var network = Rules.new()
	network.site_locked = true
	check(network.load_building_kit() == "", "load real transported outpost materials")
	network.position = Vector2(4000, 130)
	var outpost_cell = Vector2i(64, 0)
	var outpost_pos: Vector2 = network.cell_position(outpost_cell)
	var outpost_clear = {"5,0": {"obstacles": []}, "5,-1": {"obstacles": []}}
	var outpost_blocked = {"5,0": {"obstacles": [{"pos": outpost_pos, "size": Vector2(64, 56)}]}, "5,-1": {"obstacles": []}}
	before = JSON.stringify(network.snapshot())
	check(Construction.settle(network, outpost_cell, outpost_blocked, {}) != "", "outpost terrain rejection")
	unchanged(network, before, "rejected outpost")
	check(Construction.settle(network, outpost_cell, outpost_clear, {}) == "", "clear outpost founded through controller")
	check(network.camps.size() == 2 and network.bag.wood == 0 and network.stash.wood == 0, "outpost commits cost once without cloned stock")
	check(Occupancy.solid_at(network, Vector2.ZERO, 18, outpost_clear) and Occupancy.solid_at(network, outpost_pos, 18, outpost_clear), "founding outpost preserves both core footprints")
	# Drive actual scene entry points; replacing state must not retain an old adapter.
	var scene = load("res://scenes/main.tscn").instantiate()
	root.add_child(scene)
	await process_frame
	scene.set_process(false)
	scene.state = Rules.new()
	scene.enemies.clear()
	scene.chunks = blocked
	scene.close_home()
	scene.paused = false
	scene.build_mode = true
	scene.place_at(pos)
	check(scene.state.stash.wood == 24 and not scene.state.structures.has("2,0"), "scene cannot bypass terrain validation")
	scene.chunks = clear
	scene.place_at(pos)
	check(scene.state.stash.wood == 21 and scene.solid_at(pos, 18), "scene commits through controller and shared collision")
	scene.dismantling = true
	scene.place_at(pos)
	check(scene.state.stash.wood == 22 and not scene.solid_at(pos, 18), "scene dismantle releases collision")
	scene.queue_free()
	await process_frame
	print("BUILD CHECKS: %d passed, %d failed" % [checks - failures, failures])
	quit(0 if failures == 0 else 1)
