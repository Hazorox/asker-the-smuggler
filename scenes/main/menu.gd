extends Control
@onready var buttons :Array[Button]= [$start,$hunt,$hungry,$option]
var focused := 0

func _process(delta: float) -> void:
	# grab focus of the focused index button
	buttons[focused].grab_focus()
	
	# Change focused index based on click and current focused index
	if Input.is_action_just_pressed("down"):
		if focused==3:
			focused=0
		else:
			focused+=1
	elif Input.is_action_just_pressed("up"):
		if focused==0:
			focused=3
		else:
			focused-=1


func _on_option_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/options/options.tscn")
