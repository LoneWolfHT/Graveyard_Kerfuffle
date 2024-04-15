extends Control

func _ready():
	Audio.stop("Audio/Music.ogg")
	$Label.text = "%s gives a final shriek before they're vaporized by the fireball you summoned from the sky.\n\nYou frantically stuff the wand back into the tomb you took it from and flee the graveyard, swearing never to return." % [Settings.setting.relative_name]