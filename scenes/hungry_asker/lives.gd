extends Node2D

const game_over : PackedScene = preload("res://scenes/ui/game_over_screen.tscn")

func _physics_process(_delta: float) -> void:
	if HungryAskerGlobal.lives == 2:
		$Life.hide()
	if HungryAskerGlobal.lives == 1:
		$Life2.hide()
	if HungryAskerGlobal.lives == 0:
		HungryAskerGlobal.lives=3
		get_tree().change_scene_to_file("res://scenes/main/main.tscn")
