extends SceneTree
const Generator = preload("res://scripts/world_generator.gd")
var checks = 0
var failures = 0

func check(value: bool, message: String) -> void:
	checks += 1
	if not value:
		failures += 1
		push_error(message)

func _initialize() -> void:
	var baseline = JSON.parse_string(FileAccess.get_file_as_string("res://tests/fixtures/world_v1.json"))
	check(int(baseline.generator_version) == Generator.VERSION, "generation version")
	for key in baseline.chunks:
		var parts = key.split(",")
		var coord = Vector2i(int(parts[0]), int(parts[1]))
		var generated = Generator.generate(54854434, 1, coord)
		check(JSON.stringify(generated) == baseline.chunks[key], "released world unchanged: " + key)
		Generator.generate(54854434, 1, Vector2i(999, -887))
		check(JSON.stringify(Generator.generate(54854434, 1, coord)) == baseline.chunks[key], "generation order: " + key)
	var first_day = Generator.generate(54854434, 1, Vector2i(1, 1))
	var next_day = Generator.generate(54854434, 2, Vector2i(1, 1))
	check(first_day.loot == next_day.loot and first_day.obstacles == next_day.obstacles, "new day preserves geography and loot")
	check(first_day.zombies[0].id != next_day.zombies[0].id, "new day changes roaming enemy identity")
	check(Generator.generate(54854435, 1, Vector2i(1, 1)) != first_day, "different seed changes world")
	print("WORLD CHECKS: %d passed, %d failed" % [checks - failures, failures])
	quit(0 if failures == 0 else 1)
