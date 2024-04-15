extends CharacterBody2D

@export var MOVEMENT_SPEED: int = 200
@export var ACTIVE = true

var BOOST = false
var summon_allowed = true
var kill_allowed = true

func set_head(tex = Parts.Head[Settings.setting.player_parts.Head]):
	$Skeleton/Head/Texture.texture = tex

func set_body(tex = Parts.Body[Settings.setting.player_parts.Body]):
	$Skeleton/ArmLeft/Texture.texture = tex
	$Skeleton/ArmRight/Texture.texture = tex

func set_wand(tex = Parts.Wand[Settings.setting.player_parts.Wand]):
	$Skeleton/Wand/Texture.texture = tex

var undead = false
func _process(delta):
	if !ACTIVE:
		return

	if !Input.is_action_pressed("up") and !Input.is_action_pressed("down") and !Input.is_action_pressed("left") and !Input.is_action_pressed("right"):
		$AnimationPlayer.play("Stand")
	else:
		$AnimationPlayer.play("Walk")

	$Skeleton/Wand/WandEffectSummon.rotation = -self.rotation + (PI*0.5)
	if summon_allowed and Input.is_action_just_pressed("resurrect"):
		var spawnpos = get_parent().open_grave()

		if spawnpos:
			var preproc = clampf(spawnpos.distance_to(self.position) / 300, 0.0, 0.9)

			$Spawn.play()

			summon_allowed = false
			$Skeleton/Wand/WandEffectSummon.restart()
			$Skeleton/Wand/WandEffectSummon.preprocess = preproc
			$Skeleton/Wand/WandEffectSummon.lifetime = 0.5 + preproc
			$Skeleton/Wand/WandEffectSummon.direction = self.position.direction_to(spawnpos)

	$Skeleton/Wand/WandEffectKill.rotation = -self.rotation + (PI*0.5)
	if kill_allowed and Input.is_action_just_pressed("kill"):
		var spawnpos = get_parent().summon_meteor()
		var preproc = clampf(spawnpos.distance_to(self.position) / 300, 0.0, 0.9)

		kill_allowed = false
		$Skeleton/Wand/WandEffectKill.restart()
		$Skeleton/Wand/WandEffectKill.preprocess = preproc
		$Skeleton/Wand/WandEffectKill.lifetime = 0.5 + preproc
		$Skeleton/Wand/WandEffectKill.direction = self.position.direction_to(spawnpos)

	var detected = $UndeadDetect.get_overlapping_bodies()
	var current = get_parent().modulate
	var was_undead_found = undead

	undead = false
	for obj in detected:
		if obj.is_in_group("undead"):
			get_parent().modulate = Color(1, max(0.7, current.g - (delta/4)), max(0.7, current.b - (delta/4)))

			if !was_undead_found:
				$DeathTimer.start()

			BOOST = true
			undead = true
			break

	if not undead:
		if $BoostTimer.time_left <= 0:
			$BoostTimer.start()

		if $DeathTimer.time_left > 0:
			$DeathTimer.stop()

		get_parent().modulate = Color(1, min(1, current.g + delta), min(1, current.b + delta))

func _physics_process(_delta):
	if ACTIVE:
		self.rotation = get_global_mouse_position().angle_to_point(position) - (PI*0.5)

		self.velocity = Input.get_vector("left", "right", "up", "down") * MOVEMENT_SPEED

		if BOOST:
			self.velocity *= 0.6

		self.move_and_slide()

func _on_wand_effect_summon_finished():
	summon_allowed = true

func _on_wand_effect_kill_finished():
	kill_allowed = true


func _on_death_timer_timeout():
	get_parent().on_player_die()


func _on_boost_timer_timeout():
	BOOST = false
