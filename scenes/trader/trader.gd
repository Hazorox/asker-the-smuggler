class_name Trader
extends CharacterBody2D

const GRAVITY: int = 4200
const JUMP_SPEED: int =  -1500 

@onready var asker_animated_sprite: AnimatedSprite2D = $AskerAnimatedSprite

var is_player_caught := false

func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY * delta
	if is_on_floor():
		if Input.is_action_pressed("jump"):
			velocity.y = JUMP_SPEED
		else:
			asker_animated_sprite.play("walking")
	move_and_slide()

func _on_cuaght_detection_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("security"):
		CaughtDetection.is_player_caught = false
	if area.is_in_group("obs"):
		CaughtDetection.is_player_caught = true
