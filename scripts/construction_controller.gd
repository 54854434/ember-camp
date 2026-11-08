extends RefCounted
## Scene-facing synchronous commands: validate world + rules before spending.
const Occupancy = preload("res://scripts/world_occupancy.gd")
const BUILD_REACH = 480.0

static func in_reach(state, cell: Vector2i) -> bool:
	return state.position.distance_to(state.cell_position(cell)) <= BUILD_REACH

static func build_error(state, kind: String, cell: Vector2i, chunks: Dictionary, enemies: Dictionary) -> String:
	if not in_reach(state, cell):
		return "请靠近施工区域（480 范围内）"
	var error: String = state.can_build(kind, cell)
	if error != "":
		return error
	return Occupancy.placement_error(state, cell, chunks, enemies)

static func build(state, kind: String, cell: Vector2i, chunks: Dictionary, enemies: Dictionary) -> String:
	# Always query again on commit, even if a preview succeeded earlier.
	var error = build_error(state, kind, cell, chunks, enemies)
	if error != "":
		return error
	return state.build(kind, cell)

static func dismantle(state, cell: Vector2i) -> String:
	if not in_reach(state, cell):
		return "请靠近施工区域（480 范围内）"
	return state.dismantle(cell)

static func settle(state, cell: Vector2i, chunks: Dictionary, enemies: Dictionary) -> String:
	if not in_reach(state, cell):
		return "请靠近施工区域（480 范围内）"
	var ignored: String = "" if state.site_locked else state.core_key()
	var error = Occupancy.placement_error(state, cell, chunks, enemies, 65, 220, ignored)
	if error != "":
		return error
	return state.found_outpost(cell) if state.site_locked else state.settle(cell)

static func toggle_gate(state, cell: Vector2i, enemies: Dictionary) -> String:
	var key: String = state.cell_key(cell)
	if not state.structures.has(key) or state.structures[key].kind != "gate":
		return "这里没有营地门"
	if state.position.distance_to(state.cell_position(cell)) >= 90:
		return "请靠近营地门"
	if state.structures[key].get("open", false):
		var error = Occupancy.gate_close_error(state, cell, enemies)
		if error != "":
			return error
	return state.toggle_gate(cell)
