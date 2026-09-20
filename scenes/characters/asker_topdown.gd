extends CharacterBody2D


@export var SPEED = 200.0
@export var sprintAmount = 200
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
var cooldown_on = false
func _physics_process(_delta: float) -> void:
	# Get both horizontal and vertical directions
	var direction_y := Input.get_axis("up","down")
	var direction := Input.get_axis("left", "right")
	if direction == -1:
		sprite.flip_h=true
	else:
		sprite.flip_h=false
	# Set vertical velocity
	if direction_y:
		velocity.y=direction_y*SPEED
	else:
		velocity.y = move_toward(velocity.y,0,SPEED)
	
	# Set Horizontal Velocity
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Play Animations
	if velocity.y>0:
		sprite.play("down")
	elif velocity.y <0:
		sprite.play("up")
	else:
		if velocity.x!=0:
			sprite.play("right")
		else:
			sprite.play("idle")
	
	# Sprint function logic
	if Input.is_action_just_pressed("sprint") and Globals.can_sprint and not cooldown_on:
		sprint()

	move_and_slide()

func sprint()->void:
	# Change var and increment speed
	Globals.can_sprint=false
	SPEED += sprintAmount
	cooldown_on = true
	# await timer
	await get_tree().create_timer(1.5).timeout
	
	# Reverse
	SPEED -= sprintAmount
	await get_tree().create_timer(5).timeout
	cooldown_on = false
	Globals.can_sprint=true
