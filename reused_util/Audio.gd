extends Node

var BASE_VOL = -4

var sounds = {}

# You can add sounds here
func _ready():
	new_sound("Audio/Music.ogg", 0, true)

	new_sound("Audio/Click.ogg", -2)
	pass

func new_sound(sound_name, volume, music:bool = false):
	var audionode = AudioStreamPlayer.new()

	audionode.volume_db = BASE_VOL + volume
	audionode.stream = load("res://" + sound_name)
	sounds[sound_name] = {"node": audionode, "playpos": 0, "volume": volume, "music": music}

	add_child(audionode)

	print("Loaded Audio")

# var _time = 0
# func _process(delta):
# 	_time += delta

# 	if _time >= 0.5:
# 		_time = 0

# 		for sound in sounds:
# 			sounds[sound].node.volume_db = (BASE_VOL - (Settings.setting.audio_volume_shift / 2)) + sounds[sound].volume

func play(sound_name):
	# print(sounds[sound_name].music, Settings.setting.music_enabled)
	if sounds[sound_name]:
		if sounds[sound_name].music and Settings.setting.music_enabled or (not sounds[sound_name].music and Settings.setting.sounds_enabled):
			print("Playing sound res://" + sound_name)
			sounds[sound_name].node.play()

func play_low(sound_name, vol_shift):
	# print(sounds[sound_name].music, Settings.setting.music_enabled)
	if sounds[sound_name]:
		if sounds[sound_name].music and Settings.setting.music_enabled or (not sounds[sound_name].music and Settings.setting.sounds_enabled):
			print("Playing sound res://" + sound_name)
			sounds[sound_name].node.volume_db = (BASE_VOL - (Settings.setting.audio_volume_shift / 2)) + sounds[sound_name].volume + vol_shift
			sounds[sound_name].node.play()

func resume(sound_name):
	# print(sounds[sound_name].music, Settings.setting.music_enabled)
	if sounds[sound_name]:
		if sounds[sound_name].music and Settings.setting.music_enabled or (not sounds[sound_name].music and Settings.setting.sounds_enabled):
			print("Resuming sound res://" + sound_name)
			sounds[sound_name].node.play(sounds[sound_name].playpos)

func stop(sound_name):
	if sounds[sound_name]:
		print("Stopping sound res://" + sound_name)
		sounds[sound_name].playpos = sounds[sound_name].node.get_playback_position()
		sounds[sound_name].node.stop()