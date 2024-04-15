extends Control

func _ready():
	Audio.stop("Audio/Music.ogg")
	$Label.text = "You throw the wand away and flee from the graveyard, slamming the iron gate in the decayed face of %s.\n\nYou book the next plane out of the country, and never return." % [Settings.setting.relative_name]
