extends CanvasLayer

@onready var panel: Panel = $MarginContainer/Panel
@onready var start: Label = $MarginContainer/MarginContainer/HBoxContainer/HBoxContainer/start
@onready var textbox: RichTextLabel = $MarginContainer/MarginContainer/HBoxContainer/HBoxContainer/RichTextLabel
@onready var end: Label = $MarginContainer/MarginContainer/HBoxContainer/HBoxContainer/end
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer
@onready var sprite: AnimatedSprite2D = $MarginContainer/MarginContainer/HBoxContainer/MarginContainer/AnimatedSprite2D
@onready var queue: Array = []

var tween: Tween

var _sprite_frames_cache: Dictionary = {}

enum STATE {
	READY,
	READING,
	DONE,
}
var current = STATE.READY

func _ready() -> void:
	hide_box()
	print("ready")
	add_queue("test")
	add_queue("test2")
	add_queue("test3")
	
func hide_box() -> void:
	panel.hide()
	start.text = ""
	end.text = ""
	textbox.text = ""
	
func show_box() -> void:
	panel.show()
	start.text = "*"

func add_queue(text, sprite_path: String = "", frames: int = 0) -> void:
	queue.push_back({
		"text": text,
		"sp": sprite_path,
		"frames": frames
	})

func add_text() -> void:
	var entry = queue.pop_front()
	var text: String = entry.text
	show_box()
	textbox.text = text
	tween = create_tween()
	textbox.visible_ratio = 0.0
	var duration: float = 0.05 * text.length()
	tween.tween_property(textbox, "visible_ratio", 1.0, duration)\
		.from(0.0)\
		.set_trans(Tween.TRANS_LINEAR)\
		.set_ease(Tween.EASE_IN)
	tween.finished.connect(_on_tween_finished)
	change_state(STATE.READING)
	play_audio()
	
func _on_tween_finished() -> void:
	end.text = "v"
	audio.stop()
	change_state(STATE.DONE)
	
func change_state(next) -> void:
	current = next
	match current:
		STATE.READY:
			print("ready")
		STATE.READING:
			print("read")
		STATE.DONE:
			print("done")
			
func play_audio() -> void:
	while current == STATE.READING:
		audio.play()
		var t = pow(randf(), 2)
		var random = lerp(0.05, 0.3, t)
		await get_tree().create_timer(random).timeout

func _process(delta: float) -> void:
	match current:
		STATE.READY:
			if !queue.is_empty():
				add_text()
		STATE.READING:
			if Input.is_action_just_pressed("ui_accept"):
				textbox.visible_ratio = 1.0
				tween.stop()
				audio.stop()
				end.text = "v"
				change_state(STATE.DONE)
		STATE.DONE:
			if Input.is_action_just_pressed("ui_accept"):
				hide_box()
				change_state(STATE.READY)

func play_animation(sprite_path: String, frames: int) -> void:
	if sprite_path.is_empty() or frames =< 0:
		return
		
	
