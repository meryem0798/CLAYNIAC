extends Sprite2D


@onready var rqst: Sprite2D = $"../requests/rqst_spr"
@onready var arms: AnimatedSprite2D = $"../arms"


var argile0
var argile_left1
var argile_right1
var argile_up1
var argile_down1

var argile_up_left
var argile_up_right
var argile_up_up
var argile_up_down

var texture_history := [] #omg une pile j'utilise vraiment les cours de L1/ NSI là.... wow
var current_state := "center"


var up_pressed := false
var down_pressed := false
var left_pressed := false
var right_pressed := false
var freeze_ecran := true

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

	if Input.is_action_just_pressed('ui_left') or left_pressed:
		mdr = "left"
		arms.play('left')
	elif  Input.is_action_just_pressed('ui_right') or right_pressed:
		mdr = "right"
		arms.play('right')
	elif  Input.is_action_just_pressed('ui_up') or up_pressed:
		mdr = "up"
		arms.play('up')
	elif Input.is_action_just_pressed('ui_down') or down_pressed:
		mdr = "down"
		arms.play('down')

	if mdr != "":
		apply_direction(mdr)
		reset_buttons()


func apply_direction(mdr: String):
	if !rqst or !freeze_ecran: 
		return
		
	texture_history.append(texture)
	var result = rqst.register_input(mdr)
	
	var seq = rqst.player_sequence
	var sequence_name = "".join(seq) 
	var path = "res://sprites/argile/argile_%s.png" % sequence_name
	
	if ResourceLoader.exists(path):
		texture = load(path)
	else:
		if seq.size() >=2:
			var last_two = seq.slice(-2)
			var short_path = "res://sprites/argile/argile_%s%s.png" % [last_two[0], last_two[1]]
			if ResourceLoader.exists(short_path):
				texture = load(short_path)
				return
		
		var fallback_path = "res://sprites/argile/argile_%s.png" % mdr
		if ResourceLoader.exists(fallback_path):
			texture = load(fallback_path)

	#if result == "fail":
	#		await get_tree().create_timer(0.5).timeout
	#		reset_argile()
	
	if result == "success":
		freeze_ecran = false
		set_process(false) 
		

func undo_move():
	if texture_history.size() > 0:
		var previous_texture = texture_history.pop_back()
		texture = previous_texture
		
		rqst.undo_sequence()

func reset_argile():
	texture = argile0
	current_state = "center"
	reset_buttons()


func reset_buttons():
	up_pressed = false
	down_pressed = false
	left_pressed = false
	right_pressed = false


func _on_btn_up_pressed(): 
	up_pressed = true
func _on_btn_down_pressed(): 
	down_pressed = true
func _on_btn_left_pressed(): 
	left_pressed = true
func _on_btn_right_pressed(): 
	right_pressed = true
func _on_clear_pressed(): 
	reset_argile()


func _on_undo_pressed() -> void:
	undo_move()
