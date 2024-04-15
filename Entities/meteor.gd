extends Node2D

var rng = RandomNumberGenerator.new()

var FIRST = true

func _ready():
	rng.randomize()

	self.rotation = rng.randf_range(-PI, PI)

func _on_timer_timeout():
	if FIRST:
		FIRST = false
		$AnimationPlayer.play("Blast")
		$Timer.start(1)
		return

	$Particles.emitting = false
	$Texture.visible = false
	$ExplosionParticles.restart()

	for body in $Area.get_overlapping_bodies():
		if body.is_in_group("relative"):
			get_tree().change_scene_to_packed(preload("res://Scenes/game_over_kill.tscn"))
			body.visible = false
			body.ACTIVE = false
			body.start_death(true)
		elif body.is_in_group("undead"):
			body.visible = false
			body.ACTIVE = false
			body.start_death()
		elif body.is_in_group("player"):
			get_parent().on_player_die()

func _on_explosion_particles_finished():
	self.queue_free()


func _on_area_body_entered(body:Node2D):
	if body.is_in_group("player"):
		body.MOVEMENT_SPEED += 150
		body.BOOST = false

func _on_area_body_exited(body:Node2D):
	if body.is_in_group("player"):
		body.BOOST = false
		body.MOVEMENT_SPEED -= 150
