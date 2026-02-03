extends Node2D
@onready var home: AnimatedSprite2D = $home
@onready var knock: AudioStreamPlayer2D = $knock
@onready var continueicon: AnimatedSprite2D = $continueicon


func _on_button_pressed() -> void:
	Transition.fade_to_scene("res://scenes/oven.tscn")


func _on_button_2_pressed() -> void:
	Transition.fade_to_scene("res://scenes/mainmenu.tscn")


func _on_mainmenu_pressed() -> void:
	knock.play()
	Transition.fade_to_scene("res://scenes/mainmenu.tscn")


func _on_mainmenu_mouse_entered() -> void:
	home.play("pressed")


func _on_mainmenu_mouse_exited() -> void:
	home.play("default")


func _on_button_mouse_entered() -> void:
	continueicon.play("pressed")


func _on_button_mouse_exited() -> void:
	continueicon.play("default")
