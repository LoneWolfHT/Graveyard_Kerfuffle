extends Button

func _ready():
	self.pressed.connect(Callable(self, "_on_pressed"))

func _on_pressed():
	Audio.play("Audio/Click.ogg")
	get_tree().change_scene_to_packed(preload("res://Scenes/main_menu.tscn"))
