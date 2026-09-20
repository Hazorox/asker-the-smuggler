extends CanvasLayer

func _ready() -> void:
	print("game over ready")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		print("click at ", event.position, " hovered: ", get_viewport().gui_get_hovered_control())

func _on_restart_pressed() -> void:
	print("restart pressed")
	get_tree().paused = false
	CaughtDetection.is_player_caught = false
	get_tree().change_scene_to_file("res://scenes/school_parts/corridor.tscn")

func _on_main_menu_pressed() -> void:
	print("main menu pressed")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")
