extends Node2D

var meteor = load("res://Entities/meteor.tscn")
var undead = load("res://Entities/undead.tscn")

var rng = RandomNumberGenerator.new()

var opengrave = load("res://Textures/OpenGrave.png")

var DOFADE = false
var FADECHAREDIT = false

func _ready():
	rng.randomize()

	Audio.resume("Audio/Music.ogg")

	$Relative/Collision.disabled = true
	$Fleezone.monitoring = false

	$Player.set_head(Parts.Head[Settings.setting.player_parts.Head])
	$Player.set_body(Parts.Body[Settings.setting.player_parts.Body])
	$Player.set_wand(Parts.Wand[Settings.setting.player_parts.Wand])

func on_player_die():
	DOFADE = true
	Audio.stop("Audio/Music.ogg")
	$GameOver.visible = true

	var undeads = get_tree().get_nodes_in_group("undead")
	for x in undeads:
		x.ACTIVE = false

	$Player.ACTIVE = false

func _process(delta):
	if DOFADE:
		var newval = self.modulate.a - delta

		if newval > 0:
			self.modulate = Color(1, 1, 1, newval)
		else:
			await get_tree().create_timer(1.6).timeout
			get_tree().reload_current_scene()

	if FADECHAREDIT:
		var newval = min(1, $CharacterEdit.modulate.a + (delta/1.4))

		$CharacterEdit.modulate = Color(1, 1, 1, newval)

		if newval >= 1:
			FADECHAREDIT = false
			$Relative.visible = true

func open_grave():
	var children = get_tree().get_nodes_in_group("grave")

	if children.size() > 0:
		var newundead = undead.instantiate()
		var child = children[rng.randi_range(0, children.size()-1)]

		child.remove_from_group("grave")
		child.texture = opengrave

		newundead.position = child.position
		self.add_child(newundead)

		return newundead.position
	elif get_tree().get_nodes_in_group("undead").size() <= 1 and !$Relative.visible:
		$Player.position.y = min(650, $Player.position.y)
		$Player.ACTIVE = false
		FADECHAREDIT = true
		$CharacterEdit.modulate.a = 0
		$CharacterEdit.visible = true

		return $Relative.position

	return false

func summon_meteor():
	var newmeteor = meteor.instantiate()

	newmeteor.position = get_global_mouse_position().move_toward(
		Vector2(
		rng.randi_range($ShootAreaMin.position.x, $ShootAreaMax.position.x),
		rng.randi_range($ShootAreaMin.position.y, $ShootAreaMax.position.y)
		),
		rng.randi_range(10, 400)
	)

	self.add_child(newmeteor)

	return newmeteor.position

func on_charedit_close():
	$RelativeTimer.start()
	$Relative/Collision.disabled = false
	$Relative.add_to_group("undead")

	$Fleezone.monitoring = true
	$Fleezone.visible = true
	$Player.ACTIVE = true

func _on_relative_timer_timeout():
	$Relative.ACTIVE = true

func _on_fleezone_body_entered(body:Node2D):
	if $Fleezone.monitoring and body.is_in_group("player"):
		$Fleezone/FleeTimer.start()

func _on_flee_timer_timeout():
	var overlap = $Fleezone.get_overlapping_bodies()

	if overlap.size() > 0 and overlap[0].is_in_group("player"):
		get_tree().change_scene_to_packed(preload("res://Scenes/game_over_flee.tscn"))
