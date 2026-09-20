extends Node2D

const ASKER_START_POS := Vector2(450, 485)
const GAURD_START_POS := Vector2(70, 485)
const CAM_START_POS := Vector2(640, 360)
const SCORE_MODIFIER: int = 10
const START_SPEED : float = 8.0
const MAX_SPEED : int = 30
const SPEED_MODIFIER : float = 5000
const MAX_DIFFICULTY : int = 2
const MIN_OBSTACLE_GAP: int = 700
const MAX_OBSTACLE_GAP: int = 1200
@onready var dialog: CanvasLayer = $CanvasLayer

@onready var pause_menu_scene := preload("res://scenes/ui/pause_menu.tscn")
@onready var game_oveer_scene := preload("res://scenes/ui/game_over_screen.tscn")

var screen_size : Vector2i
var ground_height : int
var score : int
var speed : float
var game_running := false
var banana_scene := preload("res://scenes/banana.tscn")
var bin_scene := preload("res://scenes/trash_bin.tscn")
var obstacle_types := [banana_scene, bin_scene]
var obstacles : Array
var last_obs
var difficulty : int

func _ready() -> void:
	screen_size = get_window().size
	ground_height = -50
	new_game()

func _process(_delta: float) -> void:
	pause_game()
	game_over()
	if dialog.is_active():
		return
	speed = START_SPEED + score / SPEED_MODIFIER
	if speed > MAX_SPEED:
		speed = MAX_SPEED
	adjust_difficulty()
	generate_obs()
	%Asker.position.x += speed
	$Characters/SecurityGaurd.position.x += speed
	$Camera2D.position.x += speed
	if $Camera2D.position.x - $Ground.position.x > screen_size.x * 1.2:
		$Ground.position.x += screen_size.x
	score += speed
	show_score()
	for obs in obstacles:
		if obs.position.x < %Asker.position.x - 100:
			obstacles.erase(obs)
			obs.queue_free()
	

func new_game() -> void:
	score = 0
	game_running = false
	difficulty = 0
	%Asker.position = ASKER_START_POS
	%Asker.velocity = Vector2i(0, 0)
	$Characters/SecurityGaurd.velocity = Vector2i(0, 0)
	$Characters/SecurityGaurd.position = GAURD_START_POS
	$Camera2D.position = CAM_START_POS

func show_score() -> void:
	$Labels.get_node("ScoreLabel").text = "Score: " + str(score / SCORE_MODIFIER)

func generate_obs() -> void:
	var camera_right_edge = $Camera2D.position.x + (screen_size.x / 2.0)
	if obstacles.is_empty() or last_obs.position.x < camera_right_edge + 300:
		var obs_type = obstacle_types.pick_random()
		var max_obs = difficulty + 1
		var base_x : float
		if obstacles.is_empty():
			base_x = camera_right_edge + randi_range(MIN_OBSTACLE_GAP, MAX_OBSTACLE_GAP)
		else:
			base_x = last_obs.position.x + randi_range(MIN_OBSTACLE_GAP, MAX_OBSTACLE_GAP)
		for i in range(randi() % max_obs + 1):
			var obs = obs_type.instantiate()
			var sprite = obs.get_node("Sprite2D")
			var obs_height = sprite.texture.get_height()
			var obs_scale = sprite.scale
			var obs_x : float = base_x + (i * 100)
			var obs_y : float = screen_size.y - ground_height - (obs_height * obs_scale.y / 2) * 5
			last_obs = obs
			add_obs(obs, obs_x, obs_y)

func add_obs(obs, x, y) -> void:
	obs.position = Vector2(x, y)
	obs.body_entered.connect(hit_obs)
	add_child(obs)
	obstacles.append(obs)

func adjust_difficulty():
	difficulty = score / SPEED_MODIFIER
	if difficulty > MAX_DIFFICULTY:
		difficulty = MAX_DIFFICULTY	

func hit_obs(body):
	if body.name == "Asker":
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
