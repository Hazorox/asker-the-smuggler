extends CanvasLayer

@onready var panel: Panel = $MarginContainer/Panel
@onready var box_bg: Panel = $MarginContainer/MarginContainer/Panel
@onready var start: Label = $MarginContainer/MarginContainer/HBoxContainer/HBoxContainer/start
@onready var textbox: RichTextLabel = $MarginContainer/MarginContainer/HBoxContainer/HBoxContainer/RichTextLabel
@onready var end: Label = $MarginContainer/MarginContainer/HBoxContainer/HBoxContainer/end
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer
@onready var sprite: AnimatedSprite2D = $MarginContainer/MarginContainer/HBoxContainer/MarginContainer/AnimatedSprite2D
@onready var queue: Array = []
@onready var choices: Array = []
@onready var callback: Callable
@onready var index: int = 0

var tween: Tween

var _sprite_frames_cache: Dictionary = {}

enum STATE {
	READY,
	READING,
	CHOOSING,
	DONE,
}
var current = STATE.READY

func _ready() -> void:
	hide_box()
	print("ready")
	roll()
	
func roll():
	var r = 15
	if r == 6:
		add_queue("Try to catch me, old head.", "res://assets/dialog/askar.png", 2)
		add_queue("Iam goin to kill u, askar", "res://assets/dialog/securitygaurdavater.png", 3)
		
	if r == 15:
		add_queue("come back here u maggot", "res://assets/dialog/securitygaurdavater.png", 3)
	
	if r == 23:
		add_queue("Who would u like me to send u", "res://assets/dialog/securitygaurdavater.png", 3)
		add_choice_queue(["Mr. Atef (the princeple)", "Mrs. Essra (the Dorm keeper)", "Me"],func(i): print("picked index ", i))
		add_queue("ur choices don't matter to me, I will punish u myself anyways", "res://assets/dialog/securitygaurdavater.png", 3)
	await get_tree().create_timer(1.0).timeout
	
func hide_box() -> void:
	panel.hide()
	box_bg.hide()
	start.text = ""
	end.text = ""
	textbox.text = ""
	sprite.hide()
	
func show_box() -> void:
	panel.show()
	box_bg.show()
	start.text = "*"
	sprite.show()

func add_queue(text, sprite_path: String = "", frames: int = 0) -> void:
	queue.push_back({
		"type": "text",
		"text": text,
		"sp": sprite_path,
		"frames": frames
	})
	
func add_choice_queue(options: Array, callback: Callable = Callable()) -> void:
	queue.push_back({
		"type": "choice",
		"options": options,
		"callback": callback
	})

func add_text(entry: Dictionary) -> void:
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
	play_animation(entry.sp, entry.frames)
	
func add_choice(entry: Dictionary):
	choices = entry.options
	callback = entry.callback
	index = 0
	show_box()
	change_state(STATE.CHOOSING)
	render_choices()
	
func render_choices():
	var lines: Array = []
	for i in choices.size():
		var pre
		if i == index:
			pre = ">"
		else:
			pre = " "
		lines.append(pre + str(choices[i]))
	textbox.text = "\n".join(lines)
	textbox.visible_ratio = 1.0
	
func confirm_choice():
	end.text = "v"
	change_state(STATE.DONE)
	if callback.is_valid():
		callback.call(index)
	
func _on_tween_finished() -> void:
	end.text = "v"
	audio.stop()
	sprite.stop()
	change_state(STATE.DONE)
	
func change_state(next) -> void:
	current = next
	match current:
		STATE.READY:
			print("ready")
		STATE.READING:
			print("read")
		STATE.CHOOSING:
			print("choose")
		STATE.DONE:
			print("done")
			
func play_audio() -> void:
	while current == STATE.READING:
		audio.play()
		var t = pow(randf(), 5)
		var random = lerp(0.05, 0.3, t)
		await get_tree().create_timer(random).timeout

func _process(delta: float) -> void:
	match current:
		STATE.READY:
			if !queue.is_empty():
				var entry = queue.pop_front()
				match entry.type:
					"text":
						add_text(entry)
					"choice":
						add_choice(entry)
		STATE.READING:
			if Input.is_action_just_pressed("ui_accept"):
				textbox.visible_ratio = 1.0
				tween.stop()
				audio.stop()
				sprite.stop()
				end.text = "v"
				change_state(STATE.DONE)
		STATE.CHOOSING:
			if Input.is_action_just_pressed("down"):
				index = (index + 1) % choices.size()
				render_choices()
			if Input.is_action_just_pressed("up"):
				index = (index - 1 + choices.size()) % choices.size()
				render_choices()
			if Input.is_action_just_pressed("ui_accept"):
				confirm_choice()
		STATE.DONE:
			if Input.is_action_just_pressed("ui_accept"):
				hide_box()
				change_state(STATE.READY)

func play_animation(sprite_path: String, frames: int):
	if sprite_path.is_empty() or frames <= 0:
		return
	
	var frame = get_frames(sprite_path, frames)
	if frame == null:
		return
		
	sprite.sprite_frames = frame.frames
	sprite.scale = Vector2(148 / frame.frame_size.x, 148/ frame.frame_size.y)
	sprite.play("talk")
	
		
func get_frames(sprite_path: String, frames: int):
	var cache_key = "%s:%d" % [sprite_path, frames]
	if _sprite_frames_cache.has(cache_key):
		return _sprite_frames_cache[cache_key]
	
	var texture: Texture2D = load(sprite_path)
	if texture == null:
		return null
		
	var h = texture.get_height()
	var w = texture.get_width() / frames
	var fs = SpriteFrames.new()
	fs.add_animation("talk")
	fs.set_animation_loop("talk", true)
	fs.set_animation_speed("talk", 8)
	
	for i in frames:
		var at = AtlasTexture.new()
		at.atlas = texture
		at.region = Rect2(i * w, 0, w, h)
		fs.add_frame("talk", at)
		
	var data = {"frames": fs, "frame_size": Vector2(w, h)}
	_sprite_frames_cache[cache_key] = data
	return data
	
	
	
