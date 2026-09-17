extends Button

@onready var active :=false
func _ready()->void:
	pressed.connect(on_pressed)
	for action in InputMap.get_actions():
		print(name)
		if action==name:
			var events := InputMap.action_get_events(action)
			if events.size()>0:
				var e := events[0]
				if e is InputEventKey:
					text = (e as InputEventKey).as_text_physical_keycode()
			break

func on_pressed()->void:
	text="?"
	active = not active

func _input(event: InputEvent) -> void:
	if active:
		if (event is InputEventKey || (event is InputEventMouseButton && event.pressed )):
			if event.keycode == KEY_ESCAPE:
				active=false
				text= InputMap.action_get_events(name)[0].as_text().trim_suffix(" - Physical")
				return
			InputMap.action_erase_events(name)
			InputMap.action_add_event(name,event)
			text=event.as_text()
			active=false
