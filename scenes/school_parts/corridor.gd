extends Node2D

@onready var pause_menu_scene := preload("res://scenes/ui/pause_menu.tscn")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pause_game()

func pause_game() -> void:
	get_tree().paused = true
	var pause_menu = pause_menu_scene.instantiate()
	add_child(pause_menu)
