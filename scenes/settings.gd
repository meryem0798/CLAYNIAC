extends Node2D
@onready var mainmenu: Button = $mainmenu
@onready var home: AnimatedSprite2D = $home
@onready var knock: AudioStreamPlayer2D = $knock


func _on_mainmenu_pressed() -> void:
	knock.play()
	Transition.fade_to_scene("res://scenes/mainmenu.tscn")

func _on_mainmenu_mouse_entered() -> void:
	home.play("pressed")


func _on_mainmenu_mouse_exited() -> void:
	home.play("default")
