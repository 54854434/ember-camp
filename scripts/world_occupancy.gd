extends RefCounted
## Read live authoritative structures/chunks; no second mutable occupancy cache.
const HALF_STRUCTURE = 27.0
const PLAYER_RADIUS = 18.0
const ENEMY_RADIUS = 15.0

static func structure_rect(state, cell: Vector2i) -> Rect2:
	return Rect2(state.cell_position(cell) - Vector2.ONE * HALF_STRUCTURE, Vector2.ONE * HALF_STRUCTURE * 2)

static func blocks_movement(building: Dictionary, blueprints: Dictionary) -> bool:
	var kind: String = building.kind
	if kind == "gate":
		return not building.get("open", false)
	return kind == "core" or bool(blueprints[kind].solid)

static func obstacles_near(state, pos: Vector2, radius: float, chunks: Dictionary, fill_missing: bool = false) -> Array:
	var result: Array = []
	# Include props whose centers lie just across a queried region boundary.
	var margin = Vector2.ONE * (radius + 64.0)
	var low = Vector2i(floori((pos.x - margin.x) / state.CHUNK), floori((pos.y - margin.y) / state.CHUNK))
	var high = Vector2i(floori((pos.x + margin.x) / state.CHUNK), floori((pos.y + margin.y) / state.CHUNK))
	for x in range(low.x, high.x + 1):
		for y in range(low.y, high.y + 1):
			var cell = Vector2i(x, y)
			var key: String = state.cell_key(cell)
			var data: Dictionary
			if chunks.has(key):
				data = chunks[key]
			elif fill_missing:
				# Read terrain only: never spawn enemies or alter the streamer's residency.
				data = state.chunk_data(cell)
			else:
				continue
			result.append_array(data.obstacles)
	return result

static func solid_at(state, pos: Vector2, radius: float, chunks: Dictionary) -> bool:
	var center: Vector2i = state.cell_at(pos)
	var reach = ceili((radius + HALF_STRUCTURE) / state.CELL)
	for x in range(-reach, reach + 1):
		for y in range(-reach, reach + 1):
			var cell = center + Vector2i(x, y)
			var key: String = state.cell_key(cell)
			if state.structures.has(key) and blocks_movement(state.structures[key], state.BLUEPRINTS):
				if structure_rect(state, cell).grow(radius).has_point(pos):
					return true
	for obstacle in obstacles_near(state, pos, radius, chunks):
		if Rect2(obstacle.pos - obstacle.size / 2, obstacle.size).grow(radius).has_point(pos):
			return true
	return false

static func placement_error(state, cell: Vector2i, chunks: Dictionary, enemies: Dictionary, clearance: float = HALF_STRUCTURE, enemy_clearance: float = 65.0, ignored_structure: String = "") -> String:
	var pos: Vector2 = state.cell_position(cell)
	var footprint = Rect2(pos - Vector2.ONE * clearance, Vector2.ONE * clearance * 2)
	# Walkable gates/traps still reserve their construction footprint.
	for key in state.structures:
		if key != ignored_structure and footprint.intersects(structure_rect(state, state.key_cell(key)), true):
			return "这里已有设施或施工空间不足"
	for obstacle in obstacles_near(state, pos, clearance, chunks, true):
		if footprint.intersects(Rect2(obstacle.pos - obstacle.size / 2, obstacle.size), true):
			return "地面被天然障碍物占用"
	for enemy in enemies.values():
		if pos.distance_to(enemy.pos) <= enemy_clearance:
			return "敌人正在占据施工区域"
	return ""

static func gate_close_error(state, cell: Vector2i, enemies: Dictionary) -> String:
	var footprint = structure_rect(state, cell)
	if footprint.grow(PLAYER_RADIUS).has_point(state.position):
		return "你正站在门口，请先离开门框"
	for enemy in enemies.values():
		if footprint.grow(ENEMY_RADIUS).has_point(enemy.pos):
			return "敌人占据门口，无法关门"
	return ""
