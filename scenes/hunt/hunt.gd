extends Node2D
@onready var pause = $PauseMenu
const food_scene = preload("res://scenes/hunt/hunt_food.tscn")
@export var max = 6
func _ready()->void:
	for i in range(max):
		spawn_food()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pause.visible=true
		get_tree().paused=true

func spawn_food()->void:
	var food_instance = food_scene.instantiate()
	food_instance.position = Vector2(randf_range(0,1200),randf_range(0,720))
	food_instance.eaten.connect(_on_food_eaten)
	add_child.call_deferred(food_instance)
	
func _on_food_eaten()->void:
	spawn_food()
