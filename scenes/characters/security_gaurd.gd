class_name SecurityGuard
extends CharacterBody2D

const SPEED := 225

@onready var asker: CharacterBody2D = %Asker
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player_detection_area: Area2D = $PlayerDetectionArea

var is_player_in_sight := false

func _process(_delta: float) -> void:
	if is_player_in_sight:
		var direction := global_position.direction_to(asker.global_position)
		velocity = direction * SPEED
		move_and_slide()
		set_animation()
	else:
		velocity = Vector2.ZERO
		animated_sprite.play("idle")

func set_animation() -> void:
	if velocity.x > 0:
		animated_sprite.scale.x = -1
		player_detection_area.scale.x = -1
		animated_sprite.play("walking")
	elif velocity.x < 0:
		animated_sprite.scale.x = 1
		player_detection_area.scale.x = 1
		animated_sprite.play("walking")

func _on_player_detection_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("asker"):
		is_player_in_sight = true

func _on_player_detection_area_area_exited(area: Area2D) -> void:
	if area.is_in_group("asker"):
		is_player_in_sight = false
