extends Node2D

var FADE_LOADING = false

var characteredit

func _ready():
	$EverythingElse.visible = false
	$Loading.visible = true

	$EverythingElse/Volume.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))

	Parts.load_all()

	print("newrelative.Name = data.Name;")
	print("newrelative.Head = Math.min(%d, Math.max(0, data.Head));" % [Parts.Undead.Head.size()-1])
	print("newrelative.Body = Math.min(%d, Math.max(0, data.Body));" % [Parts.Undead.Body.size()-1])
	print("newrelative.Wand = Math.min(%d, Math.max(0, data.Wand));" % [Parts.Undead.Wand.size()-1])

	Settings.setting.loaded_enemies = [
		{"Name": "", "Head": Parts.Undead.Head[0], "Body": Parts.Undead.Body[0], "Wand": Parts.Undead.Wand[0]}
	]

	characteredit = preload("res://Scenes/character_edit.tscn").instantiate()
	characteredit.visible = false
	characteredit.for_player = true
	add_child(characteredit)

	Settings.update()

	$HTTPRequest.request("http://45.140.185.64:30006")

func _on_play_pressed():
	Audio.play("Audio/Click.ogg")
	get_tree().change_scene_to_file("res://Scenes/pre_grave_yard.tscn")

func _on_http_request_request_completed(_result:int, response_code:int, _headers:PackedStringArray, body:PackedByteArray):
	if response_code == 200:
		Settings.setting.enemies = JSON.parse_string(body.get_string_from_utf8())

		for i in range(Settings.setting.enemies.size()):
			var newval = Settings.setting.enemies[i].duplicate(true)

			for x in newval:
				if x in Parts.Undead:
					newval[x] = Parts.Undead[x][newval[x]]
				elif x != "Name":
					push_error("Couldn't find %s in Parts.Undead" % [x])

			Settings.setting.loaded_enemies.push_back(newval)

		Settings.update()

	$Timer.start()
	FADE_LOADING = true
	Audio.play("Audio/Click.ogg")

func _process(delta):
	if FADE_LOADING:
		var newalpha = $Loading.modulate.a - delta

		if newalpha > 0:
			$Loading.modulate = Color(1, 1, 1, newalpha)
		else:
			FADE_LOADING = false
			$Loading.queue_free()
			$CPUParticles2D.one_shot = true

func _on_timer_timeout():
	$EverythingElse.visible = true
	Audio.play("Audio/Music.ogg")

func _on_customize_pressed():
	$CharacterEdit.visible = true
	Audio.play("Audio/Click.ogg")

func _on_volume_value_changed(value:float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
