extends Node

@export var default_setting = {
	"window_position"    : DisplayServer.window_get_position(),
	"enemies"            : [],
	"relative_name"      : "your relative",
	"relative"           : {"not_submitted": true},
	"player_parts"       : {"Head": 0, "Body": 0, "Wand": 0},
	"loaded_enemies"     : [],
	"music_enabled"      : true,
	"sounds_enabled"     : true,
	"audio_volume_shift" : 0,
}

@export var setting: Dictionary = default_setting.duplicate(true)

const FILEPATH = "user://settings.save"

func _ready():
	load_from_file()

	DisplayServer.window_set_position(setting.window_position)

	if (Quit.on_quit.connect(_on_quit) != OK):
		push_error("[Settings] Failed to connect on_quit function")

	print("Settings Util Loaded: ", setting)

func _on_quit():
	_save_window_values()

func _save_window_values():
	setting.window_position = DisplayServer.window_get_position()

	update()

func restore_defaults():
	setting = default_setting.duplicate(true)

func update():
	var file = FileAccess.open(FILEPATH, FileAccess.WRITE)

	var tmp = setting.loaded_enemies
	setting.loaded_enemies = []
	file.store_var(setting)
	setting.loaded_enemies = tmp

	file.close()

func load_from_file():
	if not FileAccess.file_exists(FILEPATH):
		return

	var file = FileAccess.open(FILEPATH, FileAccess.READ_WRITE)

	var save = file.get_var()

	file.close()

	# Outdated save files will only update current settings that they contain
	for k in save:
		setting[k] = save[k]