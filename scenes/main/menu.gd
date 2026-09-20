extends Control

@onready var buttons :Array[Button]= [$start,$hunt,$option]
var focused := 0

func _process(delta: float) -> void:
	buttons[focused].grab_focus()
	if Input.is_action_just_pressed("down"):
		if focused==2:
			focused=0
		else:
			focused+=1
	elif Input.is_action_just_pressed("up"):
		if focused==0:
			focused=2
		else:
			focused-=1
