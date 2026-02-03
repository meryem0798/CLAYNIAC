extends Sprite2D

@onready var rqst: Sprite2D = $"../requests/rqst_spr"
@onready var arms: AnimatedSprite2D = $"../arms"
@onready var dialog_ui: Control = $"../DialogUI"
@onready var help: Button = $"../help"
@onready var bwomp: AudioStreamPlayer2D = $"../soundeffect1"
var bwomp_cooldown := 0.12
var bwomp_timer := 0.0
var argile0_texture = preload("res://sprites/argile/argile0.png")
@onready var up: AnimatedSprite2D = $"../up"
@onready var left: AnimatedSprite2D = $"../left"
@onready var right: AnimatedSprite2D = $"../right"
@onready var down: AnimatedSprite2D = $"../down"
@onready var undoicon: AnimatedSprite2D = $"../undoicon"
@onready var clearicon: AnimatedSprite2D = $"../clearicon"
@onready var continueicon: AnimatedSprite2D = $"../continueicon"
@onready var reverse: AudioStreamPlayer2D = $"../reverse"

var freeze_ecran := true
var base_scale := Vector2.ONE
@onready var boing: AudioStreamPlayer2D = $"../boing"

const MAX_STRETCH := 5

var stretch_count := {
	"up": 0,
	"down": 0,
	"left": 0,
	"right": 0
}


var opposite := {
	"up": "down",
	"down": "up",
	"left": "right",
	"right": "left"
}

func _ready():
	base_scale = scale
	texture = argile0_texture
	reset_stretch_count()

func _process(_delta):
	bwomp_timer = max(0.0, bwomp_timer - _delta)
	if !freeze_ecran:
		return
	
	var dir := ""
	if Input.is_action_just_pressed("ui_left"):
		dir = "left"
		left.play("pressed")
		play_bwomp()
	elif Input.is_action_just_pressed("ui_right"):
		dir = "right"
		right.play("pressed")
		play_bwomp()
	elif Input.is_action_just_pressed("ui_up"):
		dir = "up"
		up.play("pressed")
		play_bwomp()
	elif Input.is_action_just_pressed("ui_down"):
		dir = "down"
		down.play("pressed")
		play_bwomp()

	if dir != "":
		apply_direction(dir)


	if Input.is_action_just_pressed("undo"):
		undoicon.play("clicked")
		reverse.play()
		_on_undo_pressed()

	if Input.is_action_just_pressed("clear"):
		clearicon.play("clicked")
		boing.play()
		_on_clear_pressed()


func play_bwomp():
	if bwomp_timer > 0.0:
		return
	
	bwomp_timer = bwomp_cooldown
	bwomp.play(0.0)

func rebuild_argile():
	kill_tweens()
	scale = base_scale
	rotation = 0.0
	reset_stretch_count()

	for dir in rqst.player_sequence:
		apply_direction_no_register(dir)
		

func apply_direction_no_register(dir: String):
	#code totalement volé sur un tuto youtube!
	var opp = opposite[dir]
	if stretch_count[opp] > 0:
		stretch_count[opp] -= 1

	if stretch_count[dir] < MAX_STRETCH:
		stretch_count[dir] += 1

	var efficiency := 1.0 - float(stretch_count[dir]) / MAX_STRETCH
	efficiency = clamp(efficiency, 0.0, 1.0)

	match dir:
		"up":
			scale = Vector2(scale.x * (1.0 - 0.1 * efficiency),
							scale.y * (1.0 + 0.12 * efficiency))
		"down":
			scale = Vector2(scale.x * (1.0 + 0.1 * efficiency),
							scale.y * (1.0 - 0.12 * efficiency))
		"left", "right":
			scale = Vector2(scale.x * (1.0 + 0.05 * efficiency), scale.y)


func apply_direction(dir: String):
	var result = rqst.register_input(dir)
	arms.play(dir)


	var opp = opposite[dir]
	if stretch_count[opp] > 0:
		stretch_count[opp] -= 1

	if stretch_count[dir] < MAX_STRETCH:
		stretch_count[dir] += 1

	var efficiency := 1.0 - float(stretch_count[dir]) / MAX_STRETCH
	efficiency = clamp(efficiency, 0.0, 1.0)

	if efficiency <= 0.0:
		if result == "success":
			finish_transformation()
		return

	var tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)

	match dir:
		"up":
			tween.tween_property(self, "scale",
				Vector2(scale.x * (1.0 - 0.1 * efficiency),
						scale.y * (1.0 + 0.12 * efficiency)), 0.2)

		"down":
			tween.tween_property(self, "scale",
				Vector2(scale.x * (1.0 + 0.1 * efficiency),
						scale.y * (1.0 - 0.12 * efficiency)), 0.2)

		"left", "right":
			var angle = 0.1 * efficiency if dir == "right" else -0.1 * efficiency
			tween.tween_property(self, "rotation", angle, 0.1)
			tween.parallel().tween_property(
				self, "scale",
				Vector2(scale.x * (1.0 + 0.05 * efficiency), scale.y), 0.1)
			tween.tween_property(self, "rotation", 0.0, 0.1)

	if result == "success":
		finish_transformation()
		dialog_ui.visible = false
		help.visible = false



func finish_transformation():
	freeze_ecran = false

	var pot_name = rqst.get_current_pot_name()
	var final_texture = load("res://sprites/pots/%s_blank.png" % pot_name)

	var tween = create_tween()
	tween.tween_property(self, "scale", base_scale * 1.2, 0.1)
	tween.tween_callback(func(): texture = final_texture)
	tween.tween_property(self, "scale", base_scale, 0.2)\
		.set_trans(Tween.TRANS_ELASTIC)

	await get_tree().create_timer(0.5).timeout

	var arms_tween = create_tween()
	arms_tween.tween_property(arms, "position:y", arms.position.y + 260, 0.6)
	await arms_tween.finished
	arms.visible = false



func _on_undo_pressed() -> void:
	if rqst.player_sequence.is_empty():
		return
	rqst.player_sequence.pop_back()
	rebuild_argile()

func reset_to_zero():
	kill_tweens()
	scale = base_scale
	rotation = 0.0
	texture = argile0_texture
	freeze_ecran = true
	rqst.player_sequence.clear()
	reset_stretch_count()

func kill_tweens():
	for tween in get_tree().get_processed_tweens():
		if tween.is_valid() and tween.get_target() == self:
			tween.kill()

func reset_stretch_count():
	for key in stretch_count.keys():
		stretch_count[key] = 0



func _on_clear_pressed() -> void:
	reset_to_zero()

func _on_btn_up_pressed(): 
	if freeze_ecran: 
		play_bwomp()
		apply_direction("up")
func _on_btn_down_pressed(): 
	if freeze_ecran: 
		play_bwomp()
		apply_direction("down")
func _on_btn_left_pressed(): 
	if freeze_ecran: 
		play_bwomp()
		apply_direction("left")
func _on_btn_right_pressed(): 
	if freeze_ecran: 
		play_bwomp()
		apply_direction("right")
