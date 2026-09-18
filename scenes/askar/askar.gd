extends CharacterBody2D

const SPEED := 250

@onready var asker_animated_sprite: AnimatedSprite2D = $AskerAnimatedSprite

func _process(_delta: float) -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	velocity = direction * SPEED
	move_and_slide()
	set_animation()

func set_animation() -> void:
	if velocity.x > 0:
		asker_animated_sprite.scale.x = 1
		asker_animated_sprite.play("walking")
	elif velocity.x < 0:
		asker_animated_sprite.scale.x = -1
		asker_animated_sprite.play("walking")
	elif velocity.y != 0:
		asker_animated_sprite.play("walking")
	else:
		asker_animated_sprite.play("idle")
