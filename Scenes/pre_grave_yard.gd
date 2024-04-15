extends Control

func start_game():
	get_tree().change_scene_to_file("res://Scenes/grave_yard.tscn")

func _ready():
	$Wand.texture = Parts.Wand[Settings.setting.player_parts.Wand]
	
	$Player.set_head()
	$Player.set_body()

func _on_button_pressed():
	start_game()
