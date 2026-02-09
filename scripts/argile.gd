extends Sprite2D


@onready var rqst: Sprite2D = $"../requests/rqst_spr"
@onready var arms: AnimatedSprite2D = $"../arms"
@onready var dialog_ui: Control = $"../DialogUI"
@onready var help: Button = $"../help"
@onready var bwomp: AudioStreamPlayer2D = $"../soundeffect1"
@onready var up: AnimatedSprite2D = $"../up"
@onready var left: AnimatedSprite2D = $"../left"
@onready var right: AnimatedSprite2D = $"../right"
@onready var down: AnimatedSprite2D = $"../down"
@onready var undoicon: AnimatedSprite2D = $"../undoicon"
@onready var clearicon: AnimatedSprite2D = $"../clearicon"
@onready var reverse: AudioStreamPlayer2D = $"../reverse"
@onready var boing: AudioStreamPlayer2D = $"../boing"
var active_tween: Tween 
var bwomp_cooldown := 0.12
var bwomp_timer := 0.0
var argile0_texture = preload("res://sprites/argile/argile0.png")

var freeze_ecran := true
var base_scale := Vector2.ONE
const MAX_STRETCH := 5

var stretch_count := {"up": 0, "down": 0, "left": 0, "right": 0}
var opposite := {"up": "down", "down": "up", "left": "right", "right": "left"}

func _ready():
	base_scale = scale
	texture = argile0_texture
	reset_stretch_count()

func _process(_delta):
	bwomp_timer = max(0.0, bwomp_timer - _delta)
	if !freeze_ecran: return
	
	var dir := ""
	if Input.is_action_just_pressed("ui_left"): dir = "left"
	elif Input.is_action_just_pressed("ui_right"): dir = "right"
	elif Input.is_action_just_pressed("ui_up"): dir = "up"
	elif Input.is_action_just_pressed("ui_down"): dir = "down"

	if dir != "":
		get_node("../" + dir).play("pressed") 
		play_bwomp()
		apply_direction(dir)

	if Input.is_action_just_pressed("undo"):
		undoicon.play("clicked")
		reverse.play()
		_on_undo_pressed()

	if Input.is_action_just_pressed("clear"):
		clearicon.play("clicked")
		boing.play()
		_on_clear_pressed()



func calculate_target_scale() -> Vector2:
	var new_scale = base_scale
	var y_stretch = 1.0 + (stretch_count["up"] * 0.12) - (stretch_count["down"] * 0.12)
	var x_stretch = 1.0 + (stretch_count["left"] * 0.08) + (stretch_count["right"] * 0.08) - (stretch_count["up"] * 0.05)
	
	new_scale.x *= clamp(x_stretch, 0.6, 1.8)
	new_scale.y *= clamp(y_stretch, 0.6, 1.8) 
	return new_scale

func update_stretch_counts(dir: String):
	var opp = opposite[dir]
	if stretch_count[opp] > 0:
		stretch_count[opp] -= 1
	elif stretch_count[dir] < MAX_STRETCH:
		stretch_count[dir] += 1

func apply_direction(dir: String):
	var result = rqst.register_input(dir)
	arms.play(dir)
	
	update_stretch_counts(dir)
	var target_scale = calculate_target_scale()
	
	kill_tweens() 
	active_tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)

	if dir == "left" or dir == "right":
		var angle = 0.12 if dir == "right" else -0.12
		active_tween.tween_property(self, "rotation", angle, 0.1)
		active_tween.parallel().tween_property(self, "scale", target_scale, 0.1)
		active_tween.tween_property(self, "rotation", 0.0, 0.1)
	else:
		active_tween.tween_property(self, "scale", target_scale, 0.2)

	if result == "success":
		finish_transformation()



func rebuild_argile():
	kill_tweens()
	reset_stretch_count()

	for dir in rqst.player_sequence:
		update_stretch_counts(dir)
	

	scale = calculate_target_scale()
	rotation = 0.0

func _on_undo_pressed() -> void:
	if rqst.player_sequence.is_empty(): return
	rqst.player_sequence.pop_back()
	rebuild_argile()



func play_bwomp():
	if bwomp_timer <= 0.0:
		bwomp_timer = bwomp_cooldown
		bwomp.play(0.0)

func finish_transformation():
	freeze_ecran = false
	var pot_name = rqst.get_current_pot_name()
	var final_texture = load("res://sprites/pots/%s_blank.png" % pot_name)

	kill_tweens()
	active_tween = create_tween()
	active_tween.tween_property(self, "scale", base_scale * 1.2, 0.1)
	active_tween.tween_callback(func(): texture = final_texture)
	active_tween.tween_property(self, "scale", base_scale, 0.2).set_trans(Tween.TRANS_ELASTIC)

	await get_tree().create_timer(0.5).timeout
	var arms_tween = create_tween()
	arms_tween.tween_property(arms, "position:y", arms.position.y + 260, 0.6)
	await arms_tween.finished
	arms.visible = false

func reset_to_zero():
	kill_tweens()
	scale = base_scale
	rotation = 0.0
	texture = argile0_texture
	freeze_ecran = true
	rqst.player_sequence.clear()
	reset_stretch_count()

func kill_tweens():
	if active_tween and active_tween.is_valid():
		active_tween.kill()

func reset_stretch_count():
	for key in stretch_count.keys():
		stretch_count[key] = 0

func _on_clear_pressed() -> void:
	reset_to_zero()


func _on_btn_up_pressed(): 
	if freeze_ecran: 
		apply_direction("up")
		play_bwomp()
		
func _on_btn_down_pressed(): 
	if freeze_ecran: 
		apply_direction("down")
		play_bwomp()
		
func _on_btn_left_pressed(): 
	if freeze_ecran: 
		apply_direction("left")
		play_bwomp()
		
func _on_btn_right_pressed(): 
	if freeze_ecran: 
		apply_direction("right")
		play_bwomp()
