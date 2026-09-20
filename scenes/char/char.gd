extends Control

@onready var askar: AnimatedSprite2D = $MarginContainer/Panel/MarginContainer/AnimatedSprite2D
@onready var left: Button = $left
@onready var num = 0

func _ready() -> void:
	left.pressed.connect(switch)
	
func _process(delta: float) -> void:
	if num % 2 == 0:
		askar.play("blue")
	else:
		askar.play("green")

func switch():
	num += 1	
	
func ret():
	return num
