extends CharacterBody2D


@export var SPEED = 300.0
var player:CharacterBody2D = null
@onready var sprite:AnimatedSprite2D = $AnimatedSprite2D
@onready var collision :Area2D = $catchArea
func _ready()->void:
	# get player from global group
	player = get_tree().get_first_node_in_group("asker")
	collision.body_entered.connect(catch)
func _physics_process(_delta: float) -> void:

	# Don't run untill player exists
	if player==null:
		player=get_tree().get_first_node_in_group("asker")
		return
	
	# Track Asker, The player
	var direction = (player.global_position-global_position).normalized()
	velocity = direction * SPEED
	
	# play animations
	if velocity.x!=0:
		sprite.play("walk")
	else:
		sprite.play("idle")
	move_and_slide()

func catch(body:Node2D)->void:
	if body.is_in_group("asker"):
		get_tree().paused=false
		get_tree().change_scene_to_file("res://scenes/ui/game_over_screen.tscn")
