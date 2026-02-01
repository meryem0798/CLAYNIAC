extends Control

@onready var bar: ColorRect = $Bar
@onready var success_zone: ColorRect = $Bar/SuccessZone
@onready var cursor: ColorRect = $Bar/Cursor
@onready var slider: Control = $"."
@onready var superburnt: ColorRect = $Bar/superburnt

var speed := 80.0
var direction := 1
var can_validate := true
var lvl1_finished := false

var lives = 3

func _ready():
	slider.visible = false
	cursor.position.x = 0
	direction = 1

func _process(delta):
	cursor.position.x += speed * direction * delta

	if cursor.position.x <= 0:
		cursor.position.x = 0
		direction = 1
	elif cursor.position.x + cursor.size.x >= bar.size.x:
		cursor.position.x = bar.size.x - cursor.size.x
		direction = -1

	if can_validate and Input.is_action_just_pressed("validate"):
		can_validate = false

		if is_cursor_in_zone(superburnt):
			lives -= 1
			print("non", lives)
			lvl1_finished = true
			
		elif is_cursor_in_zone(success_zone):
			print("bravo", lives)
			lvl1_finished = true
			Transition.fade_to_scene("res://scenes/paint.tscn")
		else:
			lives -= 1
			print("raté", lives)
			lvl1_finished = true

		


func is_cursor_in_zone(zone: Control) -> bool:
	var cursor_left = cursor.position.x
	var cursor_right = cursor_left + cursor.size.x

	var zone_left = zone.position.x
	var zone_right = zone_left + zone.size.x

	return cursor_right >= zone_left and cursor_left <= zone_right



func _on_button_pressed() -> void:
	if !lvl1_finished:
		slider.visible = true
	if lvl1_finished:
		slider.visible = false
