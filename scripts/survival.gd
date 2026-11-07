class_name Survival
extends RefCounted
## Pure state and rules. All world positions use integer cell keys or Vector2.
const WorldGenerator = preload("res://scripts/world_generator.gd")
const CELL = 64.0
const CHUNK = WorldGenerator.CHUNK
const SAVE_VERSION = 1
const SAVE_PATH = "user://camp_v1.json"
const ITEMS = {
	"wood": {"name": "木材", "weight": 1.0, "color": "b69565"},
	"scrap": {"name": "废金属", "weight": 1.5, "color": "9eafb1"},
	"cloth": {"name": "布料", "weight": 0.3, "color": "d9cbb0"},
	"food": {"name": "罐头", "weight": 0.7, "color": "bdc879"},
	"med": {"name": "药品", "weight": 0.3, "color": "e99589"},
	"ammo": {"name": "弹药包", "weight": 0.5, "color": "e5b967"},
	"fuel": {"name": "燃料", "weight": 1.0, "color": "df925c"}
}
const BLUEPRINTS = {
	"wall": {"name": "围墙", "cost": {"wood": 3}, "hp": 180, "solid": true},
	"gate": {"name": "营地门", "cost": {"wood": 4, "scrap": 2}, "hp": 160, "solid": false},
	"spikes": {"name": "尖刺路障", "cost": {"wood": 2, "scrap": 1}, "hp": 90, "solid": false},
	"storage": {"name": "储物箱", "cost": {"wood": 5}, "hp": 100, "solid": true},
	"workbench": {"name": "工作台", "cost": {"wood": 6, "scrap": 4}, "hp": 150, "solid": true},
	"generator": {"name": "发电机", "cost": {"scrap": 8, "fuel": 2}, "hp": 140, "solid": true},
	"turret": {"name": "自动炮台", "cost": {"scrap": 10, "ammo": 3}, "hp": 120, "solid": true},
	"beacon": {"name": "扩建信标", "cost": {"wood": 8, "scrap": 8}, "hp": 160, "solid": true}
}
var world_seed = 54854434
var day = 1
var stash = {"wood": 24, "scrap": 18, "cloth": 4, "food": 4, "med": 3, "ammo": 8, "fuel": 4}
var bag: Dictionary = {}
var structures: Dictionary = {}
var opened: Dictionary = {}
var dead: Dictionary = {}
var position = Vector2(0, 130)
var hp = 100.0
var stamina = 100.0
var hunger = 100.0
var bleeding = false
var magazine = 12
var reserve = 48
var kills = 0
var expeditions = 0
var threat = 0.0
var outside = false
var raid_active = false
var raid_wave = 0
var generator_seconds = 0.0
var turret_rounds = 0
var camp_cell = Vector2i.ZERO
var site_locked = false
var active_camp = "camp_0"
var camps: Dictionary = {}
var convoys: Array = []
var convoy_serial = 0
var save_error = ""

func _init() -> void:
	structures["0,0"] = {"kind": "core", "hp": 600.0, "camp_id": active_camp}
	camps[active_camp] = {"name": "主营地", "cell": [0, 0], "stock": stash, "threat": 0.0, "generator_seconds": 0.0, "turret_rounds": 0}

func cell_key(cell: Vector2i) -> String:
	return "%d,%d" % [cell.x, cell.y]

func key_cell(key: String) -> Vector2i:
	var bits = key.split(",")
	return Vector2i(int(bits[0]), int(bits[1]))

func cell_at(pos: Vector2) -> Vector2i:
	return Vector2i(floori((pos.x + 32) / CELL), floori((pos.y + 32) / CELL))

func cell_position(cell: Vector2i) -> Vector2:
	return Vector2(cell) * CELL

func weight() -> float:
	var result = 0.0
	for item in bag:
		result += float(ITEMS[item].weight) * int(bag[item])
	return result

func capacity() -> float:
	return 24.0

func add_loot(item: String, quantity: int) -> int:
	var fits = maxi(0, floori((capacity() - weight() + 0.0001) / float(ITEMS[item].weight)))
	var taken = mini(fits, quantity)
	if taken > 0:
		bag[item] = int(bag.get(item, 0)) + taken
	return taken

func afford(cost: Dictionary) -> bool:
	for item in cost:
		if int(stash.get(item, 0)) < int(cost[item]):
			return false
	return true

func spend(cost: Dictionary) -> bool:
	if not afford(cost):
		return false
	for item in cost:
		stash[item] = int(stash.get(item, 0)) - int(cost[item])
	return true

func claim_radius() -> float:
	var beacons = 0
	for structure in structures.values():
		if structure.kind == "beacon" and structure.get("camp_id", active_camp) == active_camp:
			beacons += 1
	return minf(1400.0, 420.0 + 160.0 * beacons)

func in_camp(pos: Vector2) -> bool:
	return pos.distance_to(camp_origin()) < 210.0

func camp_origin() -> Vector2:
	return cell_position(camp_cell)

func core_key() -> String:
	return cell_key(camp_cell)

func settle(cell: Vector2i) -> String:
	if site_locked or structures.size() > 1 or raid_active:
		return "营地已落成；正式迁营将在后续版本加入"
	if cell_position(cell).distance_to(position) < 70:
		return "核心需放在身前，请留出施工空间"
	var core = structures[core_key()].duplicate()
	structures.erase(core_key())
	camp_cell = cell
	structures[core_key()] = core
	camps[active_camp].cell = [cell.x, cell.y]
	site_locked = true
	return ""

func can_build(kind: String, cell: Vector2i) -> String:
	if not BLUEPRINTS.has(kind):
		return "未知蓝图"
	if structures.has(cell_key(cell)):
		return "这里已有设施"
	if cell_position(cell).distance_to(camp_origin()) > claim_radius():
		return "超出领地：建造扩建信标增加范围"
	if cell_position(cell).distance_to(position) < 46:
		return "请离开施工格"
	if cell == camp_cell + Vector2i(0, 1) or cell == camp_cell + Vector2i(0, 2):
		return "保留营地核心南侧通道"
	if kind in ["generator", "turret", "beacon"] and not has_kind("workbench"):
		return "先建造工作台"
	if kind == "turret" and not has_kind("generator"):
		return "先建造发电机"
	if not afford(BLUEPRINTS[kind].cost):
		return "营地材料不足"
	return ""

func build(kind: String, cell: Vector2i) -> String:
	var error = can_build(kind, cell)
	if error != "":
		return error
	spend(BLUEPRINTS[kind].cost)
	site_locked = true
	structures[cell_key(cell)] = {"kind": kind, "hp": float(BLUEPRINTS[kind].hp), "open": false, "camp_id": active_camp}
	return ""

func has_kind(kind: String) -> bool:
	for structure in structures.values():
		if structure.kind == kind and structure.get("camp_id", active_camp) == active_camp:
			return true
	return false

func dismantle(cell: Vector2i) -> String:
	var key = cell_key(cell)
	if structures.has(key) and structures[key].kind == "core":
		return "核心不能拆除"
	if not structures.has(key):
		return "请选择已有建筑"
	if structures[key].get("camp_id", active_camp) != active_camp:
		return "请先进入所属营地进行管理"
	var blueprint = BLUEPRINTS[structures[key].kind]
	for item in blueprint.cost:
		stash[item] = int(stash.get(item, 0)) + floori(int(blueprint.cost[item]) * 0.5)
	structures.erase(key)
	return ""

func damage_structure(key: String, amount: float) -> bool:
	if not structures.has(key):
		return false
	structures[key].hp = maxf(0.0, float(structures[key].hp) - amount)
	if float(structures[key].hp) <= 0 and structures[key].kind != "core":
		structures.erase(key)
		return true
	return false

func repair_all() -> String:
	var cost = {"wood": 2, "scrap": 1}
	if not spend(cost):
		return "维修需要木材 2、废金属 1"
	for key in structures:
		if structures[key].get("camp_id", active_camp) != active_camp:
			continue
		var kind = structures[key].kind
		structures[key].hp = 600.0 if kind == "core" else float(BLUEPRINTS[kind].hp)
	return ""

func extract() -> Dictionary:
	var result = bag.duplicate()
	for item in bag:
		stash[item] = int(stash.get(item, 0)) + int(bag[item])
	bag.clear()
	site_locked = true
	expeditions += 1
	outside = false
	return result

func die() -> void:
	bag.clear()
	position = camp_origin() + Vector2(0, 130)
	hp = 75.0
	stamina = 100.0
	hunger = maxf(hunger, 35.0)
	bleeding = false
	magazine = 0
	reserve = 0
	outside = false
	threat = maxf(0, threat - 10)

func heal() -> bool:
	var inventory = stash if in_camp(position) and not outside else bag
	if int(inventory.get("med", 0)) <= 0 or (hp >= 100 and not bleeding):
		return false
	inventory.med -= 1
	hp = minf(100, hp + 45)
	bleeding = false
	return true

func reload_weapon() -> void:
	var amount = mini(12 - magazine, reserve)
	magazine += amount
	reserve -= amount

func resupply() -> bool:
	if reserve >= 96 or not spend({"ammo": 1}):
		return false
	reserve += 24
	return true

func eat() -> bool:
	var inventory = stash if in_camp(position) and not outside else bag
	if hunger >= 95 or int(inventory.get("food", 0)) <= 0:
		return false
	inventory.food -= 1
	hunger = minf(100, hunger + 45)
	return true

func chunk_data(chunk: Vector2i) -> Dictionary:
	return WorldGenerator.generate(world_seed, day, chunk)

func snapshot() -> Dictionary:
	_store_active_camp()
	return {"version": SAVE_VERSION, "seed": world_seed, "day": day, "stash": stash,
		"bag": bag, "structures": structures, "opened": opened, "dead": dead,
		"position": [position.x, position.y], "hp": hp, "stamina": stamina,
		"hunger": hunger, "bleeding": bleeding, "magazine": magazine, "reserve": reserve,
		"kills": kills, "expeditions": expeditions, "threat": threat, "outside": outside,
		"raid_active": raid_active, "raid_wave": raid_wave,
		"generator_seconds": generator_seconds, "turret_rounds": turret_rounds,
		"camp_cell": [camp_cell.x, camp_cell.y], "site_locked": site_locked,
		"active_camp": active_camp, "camps": camps, "convoys": convoys, "convoy_serial": convoy_serial}

func restore(data: Dictionary) -> bool:
	if int(data.get("version", -1)) != SAVE_VERSION:
		return false
	for property in ["day", "stash", "bag", "structures", "opened", "dead", "hp", "stamina", "hunger", "bleeding", "magazine", "reserve", "kills", "expeditions", "threat", "outside", "raid_active", "raid_wave"]:
		if not data.has(property):
			return false
	var saved_camp = data.get("camp_cell", [0, 0])
	var restored_camp = Vector2i(int(saved_camp[0]), int(saved_camp[1]))
	if not data.get("structures", {}).has(cell_key(restored_camp)) or not data.has("position"):
		return false
	world_seed = int(data.get("seed", 54854434))
	for property in ["day", "stash", "bag", "structures", "opened", "dead", "hp", "stamina", "hunger", "bleeding", "magazine", "reserve", "kills", "expeditions", "threat", "outside", "raid_active", "raid_wave"]:
		set(property, data[property])
	position = Vector2(float(data.position[0]), float(data.position[1]))
	camp_cell = restored_camp
	site_locked = bool(data.get("site_locked", false))
	active_camp = str(data.get("active_camp", "camp_0"))
	camps = data.get("camps", {active_camp: {"name": "主营地", "cell": [camp_cell.x, camp_cell.y], "stock": stash, "threat": threat}})
	if not camps.has(active_camp):
		return false
	stash = camps[active_camp].stock
	convoys = data.get("convoys", [])
	convoy_serial = int(data.get("convoy_serial", 0))
	# v1 saves used global counters; migrate those only into the saved active camp.
	generator_seconds = float(camps[active_camp].get("generator_seconds", data.get("generator_seconds", 0)))
	turret_rounds = int(camps[active_camp].get("turret_rounds", data.get("turret_rounds", 0)))
	return true

func _store_active_camp() -> void:
	camps[active_camp].stock = stash
	camps[active_camp].threat = threat
	camps[active_camp].generator_seconds = generator_seconds
	camps[active_camp].turret_rounds = turret_rounds

func _activate_camp(id: String) -> void:
	# Caller validates physical arrival or pays for a newly founded camp first.
	active_camp = id
	var cell = camps[id].cell
	camp_cell = Vector2i(int(cell[0]), int(cell[1]))
	stash = camps[id].stock
	threat = float(camps[id].get("threat", 0))
	generator_seconds = float(camps[id].get("generator_seconds", 0))
	turret_rounds = int(camps[id].get("turret_rounds", 0))

func save_game(path: String = SAVE_PATH) -> bool:
	# Write-then-rename, with previous complete file retained as a backup.
	var file = FileAccess.open(path + ".tmp", FileAccess.WRITE)
	if file == null:
		save_error = "无法写入存档"
		return false
	file.store_string(JSON.stringify(snapshot()))
	file.close()
	if FileAccess.file_exists(path):
		DirAccess.copy_absolute(path, path + ".bak")
	var error = DirAccess.rename_absolute(path + ".tmp", path)
	save_error = "" if error == OK else "保存失败，请检查空间"
	return error == OK

func load_game(path: String = SAVE_PATH) -> bool:
	for candidate in [path, path + ".bak"]:
		if FileAccess.file_exists(candidate):
			var parser = JSON.new()
			if parser.parse(FileAccess.get_file_as_string(candidate)) != OK:
				continue
			var data = parser.data
			if data is Dictionary and restore(data):
				return true
	return false

func load_building_kit() -> String:
	var cost = {"wood": 8, "scrap": 6, "food": 2}
	if not afford(cost):
		return "建营包需要木材 8、废金属 6、罐头 2"
	var added_weight = 18.4
	if weight() + added_weight > capacity() + 0.001:
		return "背包需留出 18.4 kg"
	spend(cost)
	for item in cost:
		bag[item] = int(bag.get(item, 0)) + cost[item]
	return ""

func found_outpost(cell: Vector2i) -> String:
	if raid_active:
		return "先处理当前尸潮"
	if camps.size() >= 6:
		return "原型最多管理 6 座营地"
	var origin = cell_position(cell)
	for camp in camps.values():
		if origin.distance_to(Vector2(float(camp.cell[0]), float(camp.cell[1])) * CELL) < 1600:
			return "营地间至少相距 1600，避免领地重叠"
	var cost = {"wood": 8, "scrap": 6, "food": 2}
	for item in cost:
		if int(bag.get(item, 0)) < int(cost[item]):
			return "需随身携带木材 8、废金属 6、罐头 2；可在整备界面装载建营包"
	for item in cost:
		bag[item] -= cost[item]
	_store_active_camp()
	var id = "camp_%d" % camps.size()
	var stock = {"wood": 0, "scrap": 0, "cloth": 0, "food": 0, "med": 0, "ammo": 0, "fuel": 0}
	camps[id] = {"name": "前哨 %d" % camps.size(), "cell": [cell.x, cell.y], "stock": stock, "threat": 0.0, "generator_seconds": 0.0, "turret_rounds": 0}
	_activate_camp(id)
	structures[core_key()] = {"kind": "core", "hp": 600.0, "camp_id": active_camp}
	threat = 0
	site_locked = true
	return ""

func enter_camp(id: String) -> bool:
	if not camps.has(id) or raid_active:
		return false
	var cell = Vector2i(int(camps[id].cell[0]), int(camps[id].cell[1]))
	if position.distance_to(cell_position(cell)) > 210:
		return false
	_store_active_camp()
	_activate_camp(id)
	return true

func dispatch_convoy(target: String, cargo: Dictionary, escorted: bool = true) -> String:
	if target == active_camp or not camps.has(target):
		return "请选择其他营地"
	if convoys.size() >= 3:
		return "同时最多 3 支运输队"
	if cargo.is_empty():
		return "货物不能为空"
	var cost = {"fuel": 1, "food": 1}
	if escorted:
		cost.ammo = 1
	for item in cargo:
		if not ITEMS.has(item) or int(cargo[item]) <= 0:
			return "无效货物"
		cost[item] = int(cost.get(item, 0)) + int(cargo[item])
	if not spend(cost):
		return "货物或运费不足：燃料 1、罐头 1、护卫弹药包 1"
	var dest = camps[target].cell
	var distance = camp_origin().distance_to(Vector2(float(dest[0]), float(dest[1])) * CELL)
	convoy_serial += 1
	var risk = clampf(distance / 18000.0 - (0.12 if escorted else 0), 0.02, 0.4)
	var rng = RandomNumberGenerator.new()
	rng.seed = world_seed + convoy_serial * 113
	convoys.append({"source": active_camp, "target": target, "cargo": cargo.duplicate(), "seconds": maxf(30, distance / 12), "risk": risk, "ambush": rng.randf() < risk})
	return ""

func update_convoys(dt: float) -> Array:
	var messages: Array = []
	for convoy in convoys.duplicate():
		convoy.seconds -= dt
		if convoy.seconds > 0:
			continue
		var stock = camps[convoy.target].stock
		for item in convoy.cargo:
			var delivered = int(convoy.cargo[item])
			if convoy.ambush:
				delivered = maxi(0, delivered - ceili(delivered * 0.25))
			stock[item] = int(stock.get(item, 0)) + delivered
		messages.append("运输队抵达%s%s" % [camps[convoy.target].name, "，遇袭损失部分货物" if convoy.ambush else "，货物已入当地仓库"])
		convoys.erase(convoy)
	return messages
