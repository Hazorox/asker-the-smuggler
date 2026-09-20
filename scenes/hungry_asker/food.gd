extends Area2D

@onready var sprite_2d: Sprite2D = $Sprite2D

@export var food_types : Array[Texture]

var speed : int
var rotation_speed : int 
var direction_x : float

func _ready() -> void:
	sprite_2d.texture = food_types.pick_random()
	var rng := RandomNumberGenerator.new()
	var width := get_viewport().get_visible_rect().size[0]
	var random_x := rng.randi_range(0, width)
	var random_y := rng.randi_range(-150, -50)
	position += Vector2(random_x, random_y)
	speed = 150
	rotation_speed = rng.randi_range(20, 100)
	direction_x = rng.randf_range(-1, 1)

func _process(delta: float) -> void:
	position += Vector2(0, speed * delta)
	rotation_degrees += rotation_speed * delta
