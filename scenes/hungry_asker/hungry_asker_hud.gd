class_name HungryAskerHUD
extends CanvasLayer

@onready var score: Label = %Score

func _ready() -> void:
	pass 

func update_score(n : int) -> void:
	score.text = "Score: " + str(n)
