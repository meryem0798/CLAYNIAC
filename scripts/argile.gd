extends Sprite2D


@onready var rqst: Sprite2D = $"../requests/rqst_spr"


var argile0
var argile_left1
var argile_right1
var argile_up1
var argile_down1

var argile_up_left
var argile_up_right
var argile_up_up
var argile_up_down


var current_state := "center"


var up_pressed := false
var down_pressed := false
var left_pressed := false
var right_pressed := false


func _ready():
	argile0 = load("res://sprites/argile/argile0.png")
	argile_left1 = load("res://sprites/argile/argile_left.png")
	argile_right1 = load("res://sprites/argile/argile_right.png")
	argile_up1 = load("res://sprites/argile/argile_up.png")
	argile_down1 = load("res://sprites/argile/argile_down.png")

	argile_up_left = load("res://sprites/argile/argile_upleft.png")
	argile_up_right = load("res://sprites/argile/argile_upright.png")
	argile_up_up = load("res://sprites/argile/argile_upup.png")
	argile_up_down = load("res://sprites/argile/argile_updown.png")

	reset_argile()


func _process(_delta):
	var mdr := ""

	if Input.is_action_just_pressed("ui_left") or left_pressed:
		mdr = "left"
	elif Input.is_action_just_pressed("ui_right") or right_pressed:
		mdr = "right"
	elif Input.is_action_just_pressed("ui_up") or up_pressed:
		mdr = "up"
	elif Input.is_action_just_pressed("ui_down") or down_pressed:
		mdr = "down"

	if mdr != "":
		apply_direction(mdr)
		reset_buttons()


func apply_direction(mdr: String):
	if !rqst: 
		return
	var result = rqst.register_input(mdr)
	
	var seq = rqst.player_sequence
	var sequence_name = "".join(seq) 
	var path = "res://sprites/argile/argile_%s.png" % sequence_name
	
	if ResourceLoader.exists(path):
		texture = load(path)
	else:
		var fallback_path = "res://sprites/argile/argile_%s.png" % mdr
		if ResourceLoader.exists(fallback_path):
			texture = load(fallback_path)

	if result == "success" or result == "fail":
		reset_argile()


func reset_argile():
	texture = argile0
	current_state = "center"
	reset_buttons()


func reset_buttons():
	up_pressed = false
	down_pressed = false
	left_pressed = false
	right_pressed = false


func _on_btn_up_pressed(): up_pressed = true
func _on_btn_down_pressed(): down_pressed = true
func _on_btn_left_pressed(): left_pressed = true
func _on_btn_right_pressed(): right_pressed = true
func _on_clear_pressed(): reset_argile()
