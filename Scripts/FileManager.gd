extends Node


const path_domain : String = "user://"
const path_directory : String = "game_data/"
const default_path = path_domain + path_directory
const encryption_key : PackedByteArray = [
	52, 53, 129, 30, 112, 170, 24, 137,
	47, 201, 82, 108, 175, 37, 52, 144,
	201, 86, 238, 255, 184, 31, 63, 79,
	18, 153, 32, 29, 100, 205, 160, 86
]


func init_filesystem():
	var dir = DirAccess.open(path_domain)
	if !dir.dir_exists(path_directory.replace("/", "")):
		dir.make_dir(path_directory.replace("/", ""))
	
	dir.change_dir(path_directory)
	if !dir.dir_exists("saves"):
		dir.make_dir("saves")
	if !dir.dir_exists("userdata"):
		dir.make_dir("userdata")
	
	dir.change_dir("userdata")
	if !dir.dir_exists("user_programs"):
		dir.make_dir("user_programs")
	
	if !GameProgress.game_exists():
		print("Save doesn\'t exists")


func file_exists(path):
	return FileAccess.file_exists(default_path + path)


func save_file(path : String, data : String, encrypting : bool = false):
	var full_path = default_path + path
	var file : FileAccess
	if encrypting:
		file = FileAccess.open_encrypted(full_path, FileAccess.WRITE, encryption_key)
	else:
		file = FileAccess.open(full_path, FileAccess.WRITE)
	
	file.store_string(data)
	file.close()


func load_file(path : String, encrypting : bool = false):
	var full_path = default_path + path
	var file : FileAccess
	if encrypting:
		file = FileAccess.open_encrypted(full_path, FileAccess.READ, encryption_key)
	else:
		file = FileAccess.open(full_path, FileAccess.READ)
	
	var data = file.get_as_text()
	file.close()
	return data


func get_default_path() -> String:
	return default_path
