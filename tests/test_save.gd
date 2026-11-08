extends SceneTree
const Rules = preload("res://scripts/survival.gd")
const Validator = preload("res://scripts/save_validator.gd")
var checks = 0
var failures = 0

func check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		push_error(label)

func sample(name: String) -> Dictionary:
	return JSON.parse_string(FileAccess.get_file_as_string("res://tests/fixtures/save_v1_" + name + ".json"))

func write_text(path: String, text: String) -> void:
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(text)
	file.close()

func reject_without_mutation(data: Dictionary, label: String) -> void:
	var live = Rules.new()
	live.day = 19
	live.stash.wood = 83
	live.position = Vector2(900, -400)
	var before = JSON.stringify(live.snapshot())
	check(not live.restore(data), label + " rejected")
	check(JSON.stringify(live.snapshot()) == before, label + " leaves live state unchanged")
	check(not live.save_error.is_empty(), label + " has a reason")

func _init() -> void:
	var legacy = Rules.new()
	check(legacy.restore(sample("legacy")), "pre-network v1 loads")
	check(legacy.core_key() == "-20,12" and legacy.stash.wood == 9 and legacy.bag.med == 1, "legacy assets and camp retained")
	check(legacy.generator_seconds == 80.5 and legacy.turret_rounds == 7, "legacy active counters retained")
	check(legacy.structures["-18,12"].camp_id == "camp_0", "legacy structure owner migrated")
	var network = Rules.new()
	var source = sample("network")
	check(network.restore(source), "pre-local-counter network v1 loads")
	check(network.camps.camp_0.generator_seconds == 0 and network.camps.camp_0.turret_rounds == 0, "remote camp gets no cloned counters")
	check(network.generator_seconds == 80.5 and network.turret_rounds == 7, "only old active camp inherits counters")
	source.camps.camp_1.stock.food = 999
	check(network.stash.food == 3, "restore detaches input")
	var detached = network.snapshot()
	detached.camps.camp_1.stock.food = 999
	check(network.stash.food == 3, "snapshot detaches live state")
	network.update_convoys(31)
	check(network.stash.wood == 3 and network.convoys.is_empty(), "legacy cargo settles with saved ambush")
	network.update_convoys(31)
	check(network.stash.wood == 3, "legacy cargo cannot credit twice")
	var valid = sample("network")
	for mutation in [
		["version", "1"], ["day", -1], ["day", 1.5], ["hp", "100"],
		["hp", INF], ["stamina", NAN], ["bleeding", 1], ["position", [1]],
		["position", [0, "bad"]], ["camp_cell", [0.5, 1]], ["active_camp", "missing"],
		["stash", {"wood": -1}], ["bag", {"unknown": 1}], ["bag", {"wood": 1.5}],
		["structures", []], ["camps", []], ["convoys", {}], ["opened", {"x": -1}],
		["dead", {"x": 1}], ["turret_rounds", 100], ["convoy_serial", -1]
	]:
		var data = valid.duplicate(true)
		data[mutation[0]] = mutation[1]
		reject_without_mutation(data, str(mutation[0]) + "=" + str(mutation[1]))
	for field in ["day", "hp", "position", "structures", "bag"]:
		var data = valid.duplicate(true)
		data.erase(field)
		reject_without_mutation(data, "missing " + field)
	for mutation in [["target", "missing"], ["source", "missing"], ["cargo", {"wood": -1}], ["cargo", {"unknown": 2}], ["seconds", "30"], ["risk", 2], ["ambush", 1]]:
		var data = valid.duplicate(true)
		data.convoys[0][mutation[0]] = mutation[1]
		reject_without_mutation(data, "convoy " + mutation[0])
	for mutation in [["kind", "unknown"], ["hp", -1], ["camp_id", "missing"], ["open", 1]]:
		var data = valid.duplicate(true)
		data.structures["-18,12"][mutation[0]] = mutation[1]
		reject_without_mutation(data, "building " + mutation[0])
	var no_core = valid.duplicate(true)
	no_core.structures.erase("40,-10")
	reject_without_mutation(no_core, "missing remote core")
	var bad_coord = valid.duplicate(true)
	bad_coord.structures["bad"] = bad_coord.structures["-18,12"]
	reject_without_mutation(bad_coord, "invalid structure coordinate")
	var bad_stock = valid.duplicate(true)
	bad_stock.camps.camp_0.stock.wood = -2
	reject_without_mutation(bad_stock, "remote inventory")
	var mismatch = valid.duplicate(true)
	mismatch.camp_cell = [0, 0]
	reject_without_mutation(mismatch, "active coordinate mismatch")
	check(not Validator.validate([], Rules.ITEMS, Rules.BLUEPRINTS).ok, "non-object root rejected")
	var path = "user://save_regression.json"
	var live = Rules.new()
	check(not live.load_game(path) and live.save_error == "", "first launch is not corruption")
	live.stash.wood = 31
	check(live.save_game(path), "first write")
	live.stash.wood = 32
	check(live.save_game(path), "second write")
	var backup_bytes = FileAccess.get_file_as_string(path + ".bak")
	write_text(path, "{truncated")
	var recovered = Rules.new()
	check(recovered.load_game(path) and recovered.stash.wood == 31, "truncated primary recovers last valid backup")
	check(not recovered.load_notice.is_empty(), "backup recovery is visible")
	recovered.stash.wood = 40
	check(recovered.save_game(path), "save after recovery")
	check(FileAccess.get_file_as_string(path + ".bak") == backup_bytes, "corrupt primary does not poison backup")
	write_text(path, JSON.stringify({"version": 1, "bag": []}))
	check(Rules.new().load_game(path), "valid JSON with invalid schema also recovers")
	write_text(path + ".bak", "[]")
	var damaged_bytes = FileAccess.get_file_as_string(path)
	var protected = Rules.new()
	protected.stash.wood = 77
	var before = JSON.stringify(protected.snapshot())
	check(not protected.load_game(path), "two invalid files fail visibly")
	check(JSON.stringify(protected.snapshot()) == before, "failed file load does not mutate")
	check(not protected.save_game(path), "autosave cannot erase unreadable progress")
	check(FileAccess.get_file_as_string(path) == damaged_bytes and FileAccess.get_file_as_string(path + ".bak") == "[]", "both damaged files preserved")
	write_text(path, JSON.stringify(valid))
	check(protected.load_game(path) and protected.save_game(path), "successful reload unblocks saving")
	var healthy_bytes = FileAccess.get_file_as_string(path)
	DirAccess.make_dir_absolute(path + ".bak.tmp")
	protected.stash.food = 14
	check(not protected.save_game(path), "backup copy failure is reported")
	check(FileAccess.get_file_as_string(path) == healthy_bytes, "copy failure leaves primary intact")
	DirAccess.remove_absolute(path + ".bak.tmp")
	for suffix in ["", ".bak", ".tmp", ".bak.tmp"]:
		if FileAccess.file_exists(path + suffix):
			DirAccess.remove_absolute(path + suffix)
	print("SAVE CHECKS: %d passed, %d failed" % [checks - failures, failures])
	quit(0 if failures == 0 else 1)
