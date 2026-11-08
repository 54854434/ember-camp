extends RefCounted
## Pure validation/migration. Never holds or mutates the live game state.

static func number(value: Variant, low: float, high: float) -> bool:
	return (value is int or value is float) and is_finite(float(value)) and float(value) >= low and float(value) <= high

static func integer(value: Variant, low: float = 0, high: float = 2147483647) -> bool:
	return number(value, low, high) and floor(float(value)) == float(value)

static func pair(value: Variant, integral: bool = false) -> bool:
	if not value is Array or value.size() != 2:
		return false
	for component in value:
		if not (integer(component, -2147483648, 2147483647) if integral else number(component, -137438900000.0, 137438900000.0)):
			return false
	return true

static func inventory(value: Variant, items: Dictionary) -> bool:
	if not value is Dictionary:
		return false
	for item in value:
		if not item is String or not items.has(item) or not integer(value[item]):
			return false
	return true

static func cell_key(cell: Array) -> String:
	return "%d,%d" % [int(cell[0]), int(cell[1])]

static func coordinate_key(key: Variant) -> bool:
	if not key is String:
		return false
	var bits = key.split(",")
	if bits.size() != 2 or not bits[0].is_valid_int() or not bits[1].is_valid_int():
		return false
	return integer(int(bits[0]), -2147483648, 2147483647) and integer(int(bits[1]), -2147483648, 2147483647) and key == "%d,%d" % [int(bits[0]), int(bits[1])]

static func reject(field: String) -> Dictionary:
	return {"ok": false, "error": "存档字段无效：" + field}

static func validate(source: Variant, items: Dictionary, blueprints: Dictionary) -> Dictionary:
	if not source is Dictionary:
		return reject("根对象")
	if not integer(source.get("version"), 1, 1):
		return reject("version（需要v1）")
	# Work on a detached candidate; even migration cannot modify caller data.
	var data: Dictionary = source.duplicate(true)
	for field in ["day", "magazine", "reserve", "kills", "expeditions", "raid_wave"]:
		if not integer(data.get(field), 1 if field == "day" else 0, 12 if field == "magazine" else 2147483647):
			return reject(field)
	for field in ["hp", "stamina", "hunger", "threat"]:
		if not number(data.get(field), 0, 110 if field == "threat" else 100):
			return reject(field)
	for field in ["bleeding", "outside", "raid_active"]:
		if not data.get(field) is bool:
			return reject(field)
	data.seed = data.get("seed", 54854434)
	if not integer(data.seed, -9007199254740991.0, 9007199254740991.0):
		return reject("seed")
	if not pair(data.get("position")):
		return reject("position")
	for field in ["stash", "bag"]:
		if not inventory(data.get(field), items):
			return reject(field)
	for field in ["opened", "dead"]:
		if not data.get(field) is Dictionary:
			return reject(field)
		for id in data[field]:
			if not id is String or id.is_empty():
				return reject(field + ".id")
			if field == "opened" and not integer(data[field][id]):
				return reject("opened.quantity")
			if field == "dead" and not data[field][id] is bool:
				return reject("dead.flag")
	data.camp_cell = data.get("camp_cell", [0, 0])
	data.active_camp = data.get("active_camp", "camp_0")
	data.site_locked = data.get("site_locked", false)
	if not pair(data.camp_cell, true) or not data.active_camp is String or data.active_camp.is_empty() or not data.site_locked is bool:
		return reject("active_camp/camp_cell/site_locked")
	# Pre-network v1 files had only the global stock and camp coordinate.
	data.camps = data.get("camps", {data.active_camp: {"name": "主营地", "cell": data.camp_cell, "stock": data.stash, "threat": data.threat}})
	if not data.camps is Dictionary or not data.camps.has(data.active_camp):
		return reject("camps/active_camp")
	if not number(data.get("generator_seconds", 0), 0, 120) or not integer(data.get("turret_rounds", 0), 0, 24):
		return reject("旧营地计时/余弹")
	var occupied: Dictionary = {}
	for id in data.camps:
		var camp = data.camps[id]
		if not id is String or id.is_empty() or not camp is Dictionary:
			return reject("camps.id")
		if not camp.get("name") is String or not pair(camp.get("cell"), true) or not inventory(camp.get("stock"), items):
			return reject("camps." + id)
		var key = cell_key(camp.cell)
		if occupied.has(key):
			return reject("营地核心坐标重复")
		occupied[key] = id
		camp.threat = camp.get("threat", data.threat if id == data.active_camp else 0)
		camp.generator_seconds = camp.get("generator_seconds", data.get("generator_seconds", 0) if id == data.active_camp else 0)
		camp.turret_rounds = camp.get("turret_rounds", data.get("turret_rounds", 0) if id == data.active_camp else 0)
		if not number(camp.threat, 0, 110) or not number(camp.generator_seconds, 0, 120) or not integer(camp.turret_rounds, 0, 24):
			return reject("camps." + id + ".计时/威胁/余弹")
	if cell_key(data.camp_cell) != cell_key(data.camps[data.active_camp].cell):
		return reject("活跃营地坐标不一致")
	if not data.get("structures") is Dictionary:
		return reject("structures")
	for key in data.structures:
		var building = data.structures[key]
		if not coordinate_key(key) or not building is Dictionary or not building.get("kind") is String:
			return reject("structures.坐标/结构")
		var kind: String = building.kind
		if kind != "core" and not blueprints.has(kind):
			return reject("structures.kind")
		if not number(building.get("hp"), 0, 600 if kind == "core" else float(blueprints[kind].hp)):
			return reject("structures.hp")
		building.camp_id = building.get("camp_id", data.active_camp)
		if not building.camp_id is String or not data.camps.has(building.camp_id):
			return reject("structures.camp_id")
		if building.has("open") and not building.open is bool:
			return reject("structures.open")
		if kind == "core" and occupied.get(key, "") != building.camp_id:
			return reject("多余或错属的核心")
	for key in occupied:
		if not data.structures.has(key) or data.structures[key].kind != "core" or data.structures[key].camp_id != occupied[key]:
			return reject("缺失营地核心")
	data.convoys = data.get("convoys", [])
	data.convoy_serial = data.get("convoy_serial", 0)
	if not data.convoys is Array or not integer(data.convoy_serial):
		return reject("convoys/convoy_serial")
	for convoy in data.convoys:
		if not convoy is Dictionary:
			return reject("convoys.entry")
		for endpoint in ["source", "target"]:
			if not convoy.get(endpoint) is String or not data.camps.has(convoy[endpoint]):
				return reject("convoys." + endpoint)
		if convoy.source == convoy.target or not inventory(convoy.get("cargo"), items) or convoy.cargo.is_empty():
			return reject("convoys.cargo/route")
		for quantity in convoy.cargo.values():
			if int(quantity) == 0:
				return reject("convoys.cargo.quantity")
		if not number(convoy.get("seconds"), 0, 1.0e15) or not number(convoy.get("risk"), 0, 1) or not convoy.get("ambush") is bool:
			return reject("convoys.进度/风险")
	# Camp-local data is authoritative; aliases are rebuilt on commit.
	return {"ok": true, "data": data, "error": ""}
