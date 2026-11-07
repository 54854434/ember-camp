extends SceneTree
const Rules = preload("res://scripts/survival.gd")
var checks = 0
var failures = 0

func check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		push_error(label)

func _init() -> void:
	var s = Rules.new()
	check(s.claim_radius() == 420, "initial claim")
	check(s.build("wall", Vector2i(2, 0)) == "", "build in claim")
	check(s.stash.wood == 21, "construction paid once")
	check(s.build("wall", Vector2i(2, 0)) != "", "occupied rejected")
	check(s.stash.wood == 21, "rejection cannot spend")
	check(s.build("wall", Vector2i(30, 0)) != "", "outside claim rejected")
	check(s.build("wall", Vector2i(0, 1)) != "", "core escape reserved")
	check(s.build("turret", Vector2i(3, 0)) != "", "technology dependency")
	check(s.build("workbench", Vector2i(3, 0)) == "", "workbench")
	check(s.build("beacon", Vector2i(4, 0)) == "", "claim expansion")
	check(s.claim_radius() == 580, "expanded claim")
	check(s.dismantle(Vector2i.ZERO) != "", "core cannot dismantle")
	var before = s.stash.wood
	check(s.dismantle(Vector2i(2, 0)) == "", "dismantle")
	check(s.stash.wood == before + 1, "refund rounds down")
	s.stash.wood = 0
	check(s.build("wall", Vector2i(2, 0)) != "", "no free buildings")
	check(s.add_loot("scrap", 99) == 16, "weight exact fit")
	check(s.add_loot("wood", 1) == 0, "overweight rejected")
	check(is_equal_approx(s.weight(), 24), "weight cap")
	var stash_before = s.stash.scrap
	s.extract()
	check(s.stash.scrap == stash_before + 16 and s.bag.is_empty(), "extract credits once")
	s.extract()
	check(s.stash.scrap == stash_before + 16, "extract cannot duplicate")
	s.add_loot("med", 2)
	s.outside = true
	s.hp = 50
	s.bleeding = true
	check(s.heal() and s.bag.med == 1 and not s.bleeding, "field medicine uses bag")
	s.magazine = 2
	s.reserve = 3
	s.reload_weapon()
	check(s.magazine == 5 and s.reserve == 0, "partial reload conserves ammo")
	s.die()
	check(s.bag.is_empty() and s.magazine == 0 and not s.bleeding, "death loses carried kit")
	check(s.structures.has("0,0") and s.structures.has("4,0"), "death preserves base")
	for coord in [Vector2i(0, 0), Vector2i(-2, 4), Vector2i(100000, -100000)]:
		var a = s.chunk_data(coord)
		s.chunk_data(Vector2i(55, 87))
		check(a == s.chunk_data(coord), "generation independent of load order " + str(coord))
		check(s.key_cell(s.cell_key(coord)) == coord, "coordinate roundtrip")
	s.damage_structure("3,0", 10000)
	check(not s.structures.has("3,0"), "destroy structure")
	s.damage_structure("0,0", 10000)
	check(s.structures.has("0,0") and s.structures["0,0"].hp == 0, "core loss remains inspectable")
	s.position = Vector2(-805, 245)
	s.outside = true
	s.opened["-2,1/L1"] = 2
	s.raid_active = true
	s.raid_wave = 3
	s.turret_rounds = 7
	s.generator_seconds = 119.5
	var restored = Rules.new()
	check(restored.restore(JSON.parse_string(JSON.stringify(s.snapshot()))), "JSON roundtrip")
	check(restored.position == s.position and restored.outside, "position and expedition persist")
	check(int(restored.opened["-2,1/L1"]) == 2 and restored.structures.has("4,0") and float(restored.structures["0,0"].hp) == 0, "world edits persist")
	check(restored.raid_active and restored.raid_wave == 3, "raid cannot vanish by restarting")
	check(restored.turret_rounds == 7 and restored.generator_seconds == 119.5, "consumable counters persist")
	check(not Rules.new().restore({"version": 999}), "unknown schema rejected")
	var network = Rules.new()
	network.position = Vector2(900, -700)
	check(network.settle(Vector2i(16, -11)) == "", "free initial siting")
	check(network.core_key() == "16,-11" and not network.structures.has("0,0"), "core has world coordinates")
	check(network.build("wall", Vector2i(18, -11)) == "", "build relative to relocated claim")
	check(network.build("wall", Vector2i(0, 0)) != "", "old origin is not claimed")
	check(network.load_building_kit() == "", "transport materials from actual stock")
	check(is_equal_approx(network.weight(), 18.4), "kit weight")
	network.position = Vector2(4000, 200)
	check(network.found_outpost(Vector2i(64, 3)) == "", "new outpost consumes transported kit")
	check(network.camps.size() == 2 and network.active_camp == "camp_1", "separate camps")
	check(network.stash.wood == 0 and network.bag.wood == 0, "no cloned starter resources")
	check(not network.has_kind("wall"), "remote facilities do not grant local technology")
	check(network.found_outpost(Vector2i(65, 3)) != "", "overlap rejected")
	check(not network.enter_camp("camp_0"), "no teleport management")
	network.position = Vector2(1024, -704)
	check(network.enter_camp("camp_0"), "physical arrival switches warehouse")
	var source_wood = network.stash.wood
	check(network.dispatch_convoy("camp_1", {"wood": 4, "scrap": 2, "food": 1}) == "", "dispatch costs cargo and fees")
	check(network.stash.wood == source_wood - 4 and network.convoys.size() == 1, "cargo in transit not in warehouse")
	var in_transit = Rules.new()
	check(in_transit.restore(JSON.parse_string(JSON.stringify(network.snapshot()))), "network JSON roundtrip")
	check(in_transit.camps.size() == 2 and in_transit.convoys.size() == 1, "network and transit persist")
	in_transit.update_convoys(10000)
	check(in_transit.convoys.is_empty() and int(in_transit.camps.camp_1.stock.wood) >= 3, "delivered with bounded loss")
	var delivered_once = in_transit.camps.camp_1.stock.wood
	in_transit.update_convoys(10000)
	check(in_transit.camps.camp_1.stock.wood == delivered_once, "no duplicate convoy credit")
	# Active-camp aliases must not teleport turret magazines or fuel progress.
	network.turret_rounds = 23
	network.generator_seconds = 57.5
	network.position = Vector2(4096, 192)
	check(network.enter_camp("camp_1"), "physical arrival at outpost")
	check(network.turret_rounds == 0 and network.generator_seconds == 0, "new camp does not inherit main camp counters")
	network.turret_rounds = 8
	network.generator_seconds = 4.0
	network.position = Vector2(1024, -704)
	check(network.enter_camp("camp_0"), "return to main camp")
	check(network.turret_rounds == 23 and network.generator_seconds == 57.5, "main camp retains its counters")
	var saved_network = Rules.new()
	check(saved_network.restore(JSON.parse_string(JSON.stringify(network.snapshot()))), "camp counters roundtrip")
	check(int(saved_network.camps.camp_1.turret_rounds) == 8 and float(saved_network.camps.camp_1.generator_seconds) == 4.0, "inactive camp counters persist")
	var legacy = network.snapshot().duplicate(true)
	for camp in legacy.camps.values():
		camp.erase("turret_rounds")
		camp.erase("generator_seconds")
	var migrated = Rules.new()
	check(migrated.restore(legacy) and migrated.turret_rounds == 23 and migrated.generator_seconds == 57.5, "legacy global counters migrate to active camp")
	var path = "user://test_camp.json"
	check(s.save_game(path), "atomic save")
	s.hp = 42
	check(s.save_game(path), "second save creates backup")
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string("truncated")
	file.close()
	var backup = Rules.new()
	check(backup.load_game(path), "corrupt primary recovers backup")
	check(backup.position == s.position, "backup retains world")
	for suffix in ["", ".bak", ".tmp"]:
		if FileAccess.file_exists(path + suffix):
			DirAccess.remove_absolute(path + suffix)
	print("RULE CHECKS: %d passed, %d failed" % [checks - failures, failures])
	quit(0 if failures == 0 else 1)
