extends Node2D
var cfini : bool = false
@onready var playbutton: AnimatedSprite2D = $playbutton
@onready var dring: AudioStreamPlayer2D = $dring

func _ready() -> void:
	MusicPlayer.play_music(preload("res://music/little_cafe.wav"))
	#MusicPlayer.stop()

func _on_play_pressed() -> void:
	dring.play()
	Transition.fade_to_scene("res://scenes/main.tscn")







func _on_play_mouse_entered() -> void:
	playbutton.play("pressed")


func _on_play_mouse_exited() -> void:
	playbutton.play("default")
