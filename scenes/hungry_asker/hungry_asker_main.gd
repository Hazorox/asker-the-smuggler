class_name HungryAskerMain
extends Node2D

var food_scene : PackedScene = load("res://scenes/hungry_asker/food.tscn")
var bomb_scene : PackedScene = load("res://scenes/hungry_asker/bomb.tscn")
var last_difficulty_score : int = 0

@onready var HUD : HungryAskerHUD = %HungryAskerHUD
@onready var food_timer: Timer = $FoodTimer
@onready var bomb_timer: Timer = $BombTimer

var score : int:
	get:
		return score
	set(value):
		score = value
		HUD.update_score(value)

func _ready() -> void:
	score = 0
	

func _process(_delta: float) -> void:
	increase_difficulty()

func increase_difficulty() -> void:
	if HungryAskerGlobal.score > 0 and HungryAskerGlobal. score >= last_difficulty_score + 15:
		last_difficulty_score = HungryAskerGlobal.score - (HungryAskerGlobal.score % 15)
		food_timer.wait_time = max(0.2, food_timer.wait_time - 0.1)
		food_timer.start()
		bomb_timer.wait_time = max(0.2, bomb_timer.wait_time - 0.1)
		bomb_timer.start()

func _on_food_timer_timeout() -> void:
	var food = food_scene.instantiate()
	$Food.add_child(food)

func _on_bomb_timer_timeout() -> void:
	var bomb = bomb_scene.instantiate()
	$Food.add_child(bomb)
