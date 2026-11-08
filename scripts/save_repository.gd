extends RefCounted
const Validator = preload("res://scripts/save_validator.gd")

static func read_candidate(path: String, items: Dictionary, blueprints: Dictionary) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {"ok": false, "error": "文件不存在"}
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {"ok": false, "error": "无法读取文件（%d）" % FileAccess.get_open_error()}
	var text = file.get_as_text()
	var read_error = file.get_error()
	file.close()
	if read_error != OK and read_error != ERR_FILE_EOF:
		return {"ok": false, "error": "读取失败（%d）" % read_error}
	var parser = JSON.new()
	if parser.parse(text) != OK:
		return {"ok": false, "error": "JSON损坏，第%d行" % parser.get_error_line()}
	return Validator.validate(parser.data, items, blueprints)

static func save(path: String, data: Dictionary, items: Dictionary, blueprints: Dictionary) -> String:
	var candidate = Validator.validate(data, items, blueprints)
	if not candidate.ok:
		return "未保存：" + candidate.error
	var file = FileAccess.open(path + ".tmp", FileAccess.WRITE)
	if file == null:
		return "无法写入临时存档（%d）" % FileAccess.get_open_error()
	file.store_string(JSON.stringify(candidate.data))
	file.flush()
	var error = file.get_error()
	file.close()
	if error != OK:
		return "写入存档失败（%d），旧档已保留" % error
	var written = read_candidate(path + ".tmp", items, blueprints)
	if not written.ok:
		return "临时存档回读失败，旧档已保留：" + written.error
	# Never replace a healthy backup with the corrupt primary we recovered from.
	if FileAccess.file_exists(path) and read_candidate(path, items, blueprints).ok:
		error = DirAccess.copy_absolute(path, path + ".bak.tmp")
		if error != OK:
			return "备份复制失败（%d），旧档已保留" % error
		if not read_candidate(path + ".bak.tmp", items, blueprints).ok:
			return "备份校验失败，旧档已保留"
		error = DirAccess.rename_absolute(path + ".bak.tmp", path + ".bak")
		if error != OK:
			return "备份替换失败（%d），旧档已保留" % error
	error = DirAccess.rename_absolute(path + ".tmp", path)
	return "" if error == OK else "存档替换失败（%d），请检查存储空间" % error
