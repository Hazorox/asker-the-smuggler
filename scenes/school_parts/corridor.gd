extends Node2D

@onready var pause_menu_scene := preload("res://scenes/ui/pause_menu.tscn")
@onready var game_oveer_scene := preload("res://scenes/ui/game_over_screen.tscn")

func _process(_delta: float) -> void:
	pause_game()
	game_over()

func pause_game() -> void:
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = true
		var pause_menu = pause_menu_scene.instantiate()
		add_child(pause_menu)

func game_over() -> void:
	if CaughtDetection.is_player_caught == true:
		get_tree().paused = true
		var gameover_menu = game_oveer_scene.instantiate()
		add_child(gameover_menu)
