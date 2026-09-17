extends CanvasLayer

func _ready() -> void:
	visible = true

func _on_resume_pressed() -> void:
	get_tree().paused = false
	queue_free()

func _on_exit_pressed() -> void:
	get_tree().paused = false
	get_tree().quit()

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/options/options.tscn")
