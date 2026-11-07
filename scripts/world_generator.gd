extends RefCounted
## Versioned deterministic terrain recipe. No scene, inventory or save access.
const VERSION = 1
const CHUNK = 768.0
# Frozen order: adding a new item elsewhere must not change old loot tables.
const LOOT_ITEMS = ["wood", "scrap", "cloth", "food", "med", "ammo", "fuel"]

static func cell_key(cell: Vector2i) -> String:
	return "%d,%d" % [cell.x, cell.y]

static func generate(world_seed: int, day: int, chunk: Vector2i) -> Dictionary:
	# Per-coordinate seed: generation order and negative coordinates are stable.
	var rng = RandomNumberGenerator.new()
	rng.seed = (str(world_seed) + ":" + cell_key(chunk)).hash()
	var origin = Vector2(chunk) * CHUNK
	var loot: Array = []
	var obstacles: Array = []
	var zombies: Array = []
	var biome = rng.randi_range(0, 2)
	for index in range(9):
		var pos = origin + Vector2(rng.randf_range(65, 700), rng.randf_range(65, 700))
		if pos.length() < 520:
			continue
		obstacles.append({"pos": pos, "size": Vector2(64, 56) if biome == 1 else Vector2(30, 30), "type": biome})
	for index in range(4):
		var pos = origin + Vector2(100 + index % 2 * 430, 110 + index / 2 * 400)
		if pos.length() < 490:
			continue
		var item = str(LOOT_ITEMS[rng.randi_range(0, LOOT_ITEMS.size() - 1)])
		loot.append({"id": "%s/L%d" % [cell_key(chunk), index], "pos": pos, "item": item, "qty": rng.randi_range(2, 5)})
	for index in range(3):
		var pos = origin + Vector2(rng.randf_range(100, 650), rng.randf_range(100, 650))
		if pos.length() < 540:
			continue
		zombies.append({"id": "%d/%s/Z%d" % [day, cell_key(chunk), index], "pos": pos, "kind": rng.randi_range(0, 2)})
	return {"biome": biome, "loot": loot, "obstacles": obstacles, "zombies": zombies}

