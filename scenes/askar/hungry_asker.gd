extends CharacterBody2D

@onready var main: HungryAskerMain = get_tree().current_scene as HungryAskerMain
@onready var audio :AudioStreamPlayer = $bombSound
const SPEED = 700.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()

func _on_fruit_detection_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("food"):
		area.queue_free()
		main.score += 1
	elif area.is_in_group("Bomb"):
		print("Bomb Hit")
		audio.play()
		area.queue_free()
		HungryAskerGlobal.lives -= 1
