extends CharacterBody2D

@export var SPEED = 70
@export var ACTIVE = true
@export var INIT = true

var rng = RandomNumberGenerator.new()

func _ready():
	if !INIT:
		return

	rng.randomize()

	var character = Settings.setting.loaded_enemies[rng.randi_range(0, Settings.setting.loaded_enemies.size()-1)]

	if !ACTIVE:
		$Name.visible = false

	$Name/Tag.text = character.Name
	set_head(character.Head)
	set_body(character.Body)
	set_wand(character.Wand)

	$AnimationPlayer.play("Walk")

func start_death(special: bool = false):
	if not special:
		$Death.play()

func _on_death_finished():
	self.queue_free()

func set_head(tex):
	$Skeleton/Head/Texture.texture = tex

func set_body(tex):
	$Skeleton/ArmLeft/Texture.texture = tex
	$Skeleton/ArmRight/Texture.texture = tex

func set_wand(tex):
	$Skeleton/Wand/Texture.texture = tex
	$Skeleton/Wand2/Texture.texture = tex

func _process(_delta):
	$Name.rotation = -self.rotation

func _physics_process(_delta):
	if ACTIVE:
		self.rotation = get_parent().get_node("Player").position.angle_to_point(self.position) - (PI*0.5)

		self.velocity = self.position.direction_to(get_parent().get_node("Player").position) * SPEED

		move_and_slide()
