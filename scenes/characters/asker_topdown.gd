extends CharacterBody2D


@export var SPEED = 300.0
@export var sprintAmount = 150
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(_delta: float) -> void:
	var direction_y := Input.get_axis("up","down")
	var direction := Input.get_axis("left", "right")
	
	if direction_y:
		velocity.y=direction_y*SPEED
	else:
		velocity.y = move_toward(velocity.y,0,SPEED)
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if velocity.y>0:
		sprite.play("down")
	elif velocity.y <0:
		sprite.play("up")
	else:
		if velocity.x!=0:
			sprite.play("right")
		else:
			sprite.play("idle")

	move_and_slide()
