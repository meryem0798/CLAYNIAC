extends Node2D
@onready var home: AnimatedSprite2D = $home
@onready var helpicon: AnimatedSprite2D = $helpicon
@onready var up: AnimatedSprite2D = $up
@onready var left: AnimatedSprite2D = $left
@onready var right: AnimatedSprite2D = $right
@onready var down: AnimatedSprite2D = $down
@onready var undoicon: AnimatedSprite2D = $undoicon
@onready var clearicon: AnimatedSprite2D = $clearicon
@onready var continueicon: AnimatedSprite2D = $continueicon
@onready var ring: AudioStreamPlayer2D = $ring
@onready var reverse: AudioStreamPlayer2D = $reverse
@onready var boing: AudioStreamPlayer2D = $boing
@onready var knock: AudioStreamPlayer2D = $knock

func _ready():
	MusicPlayer.play_music(preload("res://music/little_cafe.wav"))
	continueicon.visible = false
	


func _on_mainmenu_pressed() -> void:
	knock.play()
	Transition.fade_to_scene("res://scenes/mainmenu.tscn")
	


func _on_mainmenu_mouse_entered() -> void:
	home.play("pressed")


func _on_mainmenu_mouse_exited() -> void:
	home.play("default")


func _on_help_mouse_entered() -> void:
	helpicon.play("pressed")


func _on_help_mouse_exited() -> void:
	helpicon.play("default")


func _on_btn_up_mouse_entered() -> void:
	up.play("click")


func _on_btn_up_mouse_exited() -> void:
	up.play("default")


func _on_btn_left_mouse_entered() -> void:
	left.play("click")


func _on_btn_left_mouse_exited() -> void:
	left.play("default")


func _on_btn_right_mouse_entered() -> void:
	right.play("click")


func _on_btn_right_mouse_exited() -> void:
	right.play("default")


func _on_btn_down_mouse_entered() -> void:
	down.play("click")


func _on_btn_down_mouse_exited() -> void:
	down.play("default")


func _on_undo_mouse_entered() -> void:
	undoicon.play("pressed")


func _on_undo_mouse_exited() -> void:
	undoicon.play("default")


func _on_clear_mouse_entered() -> void:
	
	clearicon.play("pressed")


func _on_clear_mouse_exited() -> void:
	clearicon.play("default")


func _on_finish_mouse_entered() -> void:
	continueicon.play("pressed")


func _on_finish_mouse_exited() -> void:
	continueicon.play("default")


func _on_help_pressed() -> void:
	ring.play()


func _on_undo_pressed() -> void:
	reverse.play()


func _on_clear_pressed() -> void:
	boing.play()
