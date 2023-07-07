extends CharacterBody2D
class_name Player

var health = 5
var amount = randi() % 6

@onready var cat: Sprite2D = $"Sprite2D/Cat-version1"

var direction: Vector2 = Vector2.ZERO

func _ready():
	damage()

func damage():
	health -= amount
	print(health)
	return

const SPEED = 200.0
const JUMP_VELOCITY = -350.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	flip_dir()
	die()


func flip_dir():
	if direction.x > 0:
		cat.flip_h = false
	elif direction.x < 0:
		cat.flip_h = true

func die():
	if position.y > 300:
		queue_free()
		print("You died...")
