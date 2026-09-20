class_name Main
extends Node2D

var food_scene : PackedScene = load("res://scenes/hungry_asker/food.tscn")
var bomb_scene : PackedScene = load("res://scenes/hungry_asker/bomb.tscn")
var last_difficulty_score : int = 0

@onready var HUD = %HungryAskerHUD
@onready var food_timer = %FoodTimer
@onready var bomb_timer = %BombTimer

var score : int:
	get:
		return score
	set(value):
		score = value
		HUD.update_score(value)

func _ready() -> void:
	score = 0
	

func _process(delta: float) -> void:
	pass

func _on_food_timer_timeout() -> void:
	pass # Replace with function body.


func _on_bomb_timer_timeout() -> void:
	pass # Replace with function body.
