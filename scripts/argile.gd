extends Sprite2D

# --- Textures ---
var argile0
var argile_left1
var argile_right1
var argile_up1
var argile_down1

var argile_up_left
var argile_up_right
var argile_up_up
var argile_up_down

var current_state = "center"


var up_pressed = false
var down_pressed = false
var left_pressed = false
var right_pressed = false


func _ready():
	argile0 = load("res://sprites/argile/argile0.png")
	argile_left1 = load("res://sprites/argile/argile_left1.png")
	argile_right1 = load("res://sprites/argile/argile_right1.png")
	argile_up1 = load("res://sprites/argile/argile_up1.png")
	argile_down1 = load("res://sprites/argile/argile_down1.png")

	argile_up_left = load("res://sprites/argile/argile_upleft.png")
	argile_up_right = load("res://sprites/argile/argile_upright.png")
	argile_up_up = load("res://sprites/argile/argile_upup.png")
	argile_up_down = load("res://sprites/argile/argile_updown.png")

	texture = argile0
	current_state = "center"


func _process(delta):
	var dir = ""

	if Input.is_action_just_pressed("ui_left") or left_pressed:
		dir = "left"
	elif Input.is_action_just_pressed("ui_right") or right_pressed:
		dir = "right"
	elif Input.is_action_just_pressed("ui_up") or up_pressed:
		dir = "up"
	elif Input.is_action_just_pressed("ui_down") or down_pressed:
		dir = "down"

	if dir != "":
		apply_direction(dir)
		reset_buttons()


func apply_direction(dir):
	#from 0
	if current_state == "center":
		if dir == "left":
			texture = argile_left1
			current_state = "left"
		elif dir == "right":
			texture = argile_right1
			current_state = "right"
		elif dir == "up":
			texture = argile_up1
			current_state = "up"
		elif dir == "down":
			texture = argile_down1
			current_state = "down"

	#from up
	elif current_state == "up":
		if dir == "left":
			texture = argile_up_left
			current_state = "up_left"
		elif dir == "right":
			texture = argile_up_right
			current_state = "up_right"
		elif dir == "up":
			texture = argile_up_up
			current_state = "up_up"
		elif dir == "down":
			texture = argile_up_down
			current_state = "up_down"


func reset_buttons():
	up_pressed = false
	down_pressed = false
	left_pressed = false
	right_pressed = false


func _on_btn_up_pressed() -> void:
	up_pressed = true

func _on_btn_down_pressed() -> void:
	down_pressed = true

func _on_btn_left_pressed() -> void:
	left_pressed = true

func _on_btn_right_pressed() -> void:
	right_pressed = true


func _on_clear_pressed() -> void:
	texture = argile0
	current_state = "center"
	reset_buttons()
