extends Button

@onready var active :=false
func _ready()->void:
	for action in InputMap.get_actions():
		print(name)
		if action==name:
			var events := InputMap.action_get_events(action)
			if events.size()>0:
				var e := events[0]
				if e is InputEventKey:
					text = (e as InputEventKey).as_text_physical_keycode()
			break
