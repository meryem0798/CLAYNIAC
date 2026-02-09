extends Node2D
var cfini : bool = false
@onready var playbutton: AnimatedSprite2D = $playbutton
@onready var dring: AudioStreamPlayer2D = $dring
@onready var start_2: Sprite2D = $start2
@onready var start_1: Sprite2D = $start1
@onready var gear: AnimatedSprite2D = $gear

func _ready() -> void:
	start_2.visible = false
	start_1.visible = true
	MusicPlayer.play_music(preload("res://music/little_cafe.wav"))
	#MusicPlayer.stop()

func _on_play_pressed() -> void:
	dring.play()
	Transition.fade_to_scene("res://scenes/main.tscn")







func _on_play_mouse_entered() -> void:
	start_2.visible = true
	start_1.visible = false


func _on_play_mouse_exited() -> void:
	start_2.visible = false
	start_1.visible = true


func _on_settings_pressed() -> void:
	pass # Replace with function body.


func _on_settings_mouse_entered() -> void:
	gear.play("pressed")


func _on_settings_mouse_exited() -> void:
	gear.play("default")
