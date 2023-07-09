extends CharacterBody2D
class_name Player

@export var speed: float = 200.0
@export var jump_velocity: float = -350.0

var health = 5
var amount = randi() % 6

var direction: Vector2 = Vector2.ZERO
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
var anim_locked: bool = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	damage()

func damage():
	health -= amount
	print(health)
	return

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		

	direction = Input.get_vector("left", "right", "up", "down")
	if direction:
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide()
	play_anim()
	jump()
	flip_dir()
	die()

func play_anim():
	if not anim_locked:
		if direction.x != 0:
			anim.play("run")
		else:
			anim.play("idle")

func flip_dir():
	if direction.x > 0:
		anim.flip_h = false
	elif direction.x < 0:
		anim.flip_h = true

func die():
	if position.y > 300:
		queue_free()
		print("You died...")
		
func jump():
	if direction.y != 0:
		anim.play("run")
		print(direction.y)
