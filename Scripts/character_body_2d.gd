extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var speed = 80
@export var friction = 0.1
@export var acceleration = 0.4
var is_Attacking = false
var sprint = false

func get_input():
	var input = Vector2()
	
	# Toggles and untoggles sprint
	
	if Input.is_action_pressed("sprint"):
		sprint = true
	else:
		sprint = false
	
	if sprint == true:
		speed = 140
	else:
		speed = 80
	
	# Handles right movement
	
	if Input.is_action_pressed('right') and is_Attacking == false:
		input.x += 1

		if sprint == true:
			animated_sprite_2d.play("Run_Right")
		else:
			animated_sprite_2d.play("Idle_Right")

	# Handles left movement
	
	if Input.is_action_pressed('left') and is_Attacking == false:
		input.x -= 1
		if sprint == true:
			animated_sprite_2d.play("Run_Left")
		else:
			animated_sprite_2d.play("Idle_Left")
			
	# Handles downward movement
	
	if Input.is_action_pressed('down') and is_Attacking == false:
		input.y += 1
		if not Input.is_action_pressed("right") and not Input.is_action_pressed("left"):
			if sprint == true:
				animated_sprite_2d.play("Run_Down")
			else:
				animated_sprite_2d.play("Idle_Down")
		
	# Handles upward movement
		
	if Input.is_action_pressed('up') and is_Attacking == false:
		input.y -= 1
		if not Input.is_action_pressed("left") and not Input.is_action_pressed("right"):
			if sprint == true:
				animated_sprite_2d.play("Run_Up")
			else:
				animated_sprite_2d.play("Idle_Up")
		
	# Performs idle animation
	
	if sprint == false and is_Attacking == false or input.y == 0 and input.x == 0:
		if animated_sprite_2d.animation == "Run_Right":
			animated_sprite_2d.play("Idle_Right")
		if animated_sprite_2d.animation == "Run_Left":
			animated_sprite_2d.play("Idle_Left")
		if animated_sprite_2d.animation == "Run_Up":
			animated_sprite_2d.play("Idle_Up")
		if animated_sprite_2d.animation == "Run_Down":
			animated_sprite_2d.play("Idle_Down")

	
	# Handles attack
	
	if Input.is_action_just_pressed("Attack"):
		is_Attacking = true
		if animated_sprite_2d.animation == "Idle_Down" or animated_sprite_2d.animation == "Run_Down":
			animated_sprite_2d.play("Attack_Down")
		if animated_sprite_2d.animation == "Idle_Up" or animated_sprite_2d.animation == "Run_Up":
			animated_sprite_2d.play("Attack_Up")
		if animated_sprite_2d.animation == "Idle_Left" or animated_sprite_2d.animation == "Run_Left":
			animated_sprite_2d.play("Attack_Left")
		if animated_sprite_2d.animation == "Idle_Right" or animated_sprite_2d.animation == "Run_Right":
			animated_sprite_2d.play("Attack_Right")
	return input
	
func _physics_process(delta):
	var direction = get_input()
	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * speed, acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
	move_and_slide()

# Sets character back to idle animation after attack finishes
func _on_animated_sprite_2d_animation_finished() -> void:
	is_Attacking = false
	if animated_sprite_2d.animation == "Attack_Right":
			animated_sprite_2d.play("Idle_Right")
	if animated_sprite_2d.animation == "Attack_Left":
			animated_sprite_2d.play("Idle_Left")
	if animated_sprite_2d.animation == "Attack_Up":
			animated_sprite_2d.play("Idle_Up")
	if animated_sprite_2d.animation == "Attack_Down":
			animated_sprite_2d.play("Idle_Down")
