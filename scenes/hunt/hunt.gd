extends Node2D
@onready var pause = $PauseMenu
const food_scene = preload("res://scenes/hunt_food.tscn")
@export var max = 5
func _ready()->void:
	pass

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pause.visible=true
		get_tree().paused=true
