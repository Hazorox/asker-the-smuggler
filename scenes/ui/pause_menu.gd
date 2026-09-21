extends CanvasLayer
func _on_resume_pressed() -> void:
	get_tree().paused = false
	visible=false
	

func _on_exit_pressed() -> void:
	get_tree().paused = false
	visible=false
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")
