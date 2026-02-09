extends Control

@onready var slider: Control = $"." 
@onready var superburnt: ColorRect = $Bar/superburnt
@onready var success_zone: TextureRect = $Bar/SuccessZone
@onready var bar: TextureRect = $Bar
@onready var cursor: TextureRect = $Bar/Cursor
var success_image: Image
@onready var button: Button = $"../Button"
@onready var help: Button = $"../help"

@onready var live_1: AnimatedSprite2D = $"../live1"
@onready var live_2: AnimatedSprite2D = $"../live2"
@onready var live_3: AnimatedSprite2D = $"../live3"
@onready var consignes: Label = $"../consignes"
@onready var it: Label = $"../it"
@onready var firezone: Label = $"../firezone"
@onready var enter: Label = $"../ENTER"
@onready var lmb: Label = $"../LMB"

var game_started := false
var direction := 1
var can_validate := true
var lvl1_finished := false

var lives := 3


var level := 1
var speed := 200.0
const LEVEL_SPEEDS := [200.0, 300.0, 600.0]
const MAX_LEVEL := 3


func _ready():
	slider.visible = false
	cursor.position.x = 0
	direction = 1

	live_1.play("default")
	live_2.play("default")
	live_3.play("default")


	success_image = success_zone.texture.get_image()
	success_image.convert(Image.FORMAT_RGBA8)


func is_cursor_on_visible_pixel(zone: TextureRect) -> bool:
	var cursor_center_x = cursor.position.x + cursor.size.x / 2


	var local_x = cursor_center_x - zone.position.x

	if local_x < 0 or local_x >= zone.size.x:
		return false

	#conversion vers coord image
	var img_x = int(local_x * success_image.get_width() / zone.size.x)
	var img_y = int(success_image.get_height() / 2) 

	if img_x < 0 or img_x >= success_image.get_width():
		return false

	var color = success_image.get_pixel(img_x, img_y)

	return color.a > 0.1


func _process(delta):
	if lvl1_finished:
		return

	cursor.position.x += speed * direction * delta

	if cursor.position.x <= 0:
		cursor.position.x = 0
		direction = 1
	elif cursor.position.x + cursor.size.x >= bar.size.x:
		cursor.position.x = bar.size.x - cursor.size.x
		direction = -1

	if can_validate and game_started:
			var mouse_clicked = Input.is_action_just_pressed("leftmouse")
			var key_pressed = Input.is_action_just_pressed("validate")
			
			if key_pressed or mouse_clicked:
				if mouse_clicked and help.get_global_rect().has_point(get_global_mouse_position()):
					return #2 ignore when lmb on help button lol
				
				can_validate = false
				check_result()

func check_result():
	if is_cursor_on_visible_pixel(success_zone):
		print("bravo")
		if level < MAX_LEVEL:
			level += 1
			speed = LEVEL_SPEEDS[level - 1]
			print("lvl : ", level, "vitesse : ", speed)
			reset_cursor()
			can_validate = true
		else:
			lvl1_finished = true
			Transition.fade_to_scene("res://scenes/paint.tscn")
	else:
		lose_life()


func reset_cursor():
	cursor.position.x = 0
	direction = 1


func lose_life():
	lives -= 1
	print("vies : ", lives)

	match lives:
		2:
			live_3.play("broken")
		1:
			live_2.play("broken")
		0:
			live_1.play("broken")
			lvl1_finished = true
			await get_tree().create_timer(0.4).timeout
			Transition.fade_to_scene("res://scenes/gameover_oven.tscn")

	can_validate = true


func _on_button_pressed() -> void:

	if !lvl1_finished:
		button.disabled = true
		slider.visible = true
		game_started = true

func _ifconsignesvisibles() -> void:
	consignes.visible = true
	it.visible = true
	firezone.visible = true
	enter.visible = true
	lmb.visible = true

func _on_help_pressed() -> void:
	consignes.visible = !consignes.visible
	var etat = consignes.visible
	it.visible = etat
	firezone.visible = etat
	enter.visible = etat
	lmb.visible = etat
