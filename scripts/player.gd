extends CharacterBody2D
class_name Player

@export var speed: float = 200.0
@export var jump_velocity: float = -150.0
@export var double_jump_velocity: float = -200

var fish_points: int = 0
var health = 5
var amount = randi() % 6

var direction: Vector2 = Vector2.ZERO
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
var anim_locked: bool = false
var is_in_air: bool = false
var has_double_jumped: bool = false

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
		is_in_air = true
	else:
		has_double_jumped = false
		
		if is_in_air == true:
			land()
			
		is_in_air = false
		
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			jump()
		elif not has_double_jumped:
			double_jump()
		

	direction = Input.get_vector("left", "right", "up", "down")
	if direction.x != 0 && anim.animation != "jump_end":
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide()
	play_anim()
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
	velocity.y = jump_velocity
	anim.play("jump_start")
	anim_locked = true
	
func double_jump():
	velocity.y = jump_velocity
	anim.play("jump_double")
	anim_locked = true

func land():
	anim.play("jump_end")
	anim_locked = true
	
func _on_animated_sprite_2d_animation_finished():
	if(["jump_end", "jump_start", "jump_double"].has(anim.animation)):
		anim_locked = false
		


func _on_detect_fish_body_entered(body):
	body = get_tree().get_first_node_in_group("fish_points")
	fish_points += 1
	print("hey",fish_points)
	

func _on_detect_fish_body_exited(body):
	pass # Replace with function body.
