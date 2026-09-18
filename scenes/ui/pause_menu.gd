extends CanvasLayer

@onready var options_menu_scene := preload("res://scenes/options/options.tscn")

func _ready() -> void:
	visible = true

func _on_resume_pressed() -> void:
	get_tree().paused = false
	queue_free()
	

func _on_exit_pressed() -> void:
	get_tree().paused = false
	get_tree().quit()

func _on_options_pressed() -> void:
	var options_menu = options_menu_scene.instantiate()
	add_child(options_menu)
