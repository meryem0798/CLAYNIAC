extends Node2D


func _on_play_pressed() -> void:
	Transition.fade_to_scene("res://scenes/main.tscn")
