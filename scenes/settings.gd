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


func _on_h_slider_changed() -> void:
	pass
	#AudioServer.set_bus_volume_db(AudioServer.get_bus_index("BM"), linear_to_db(value))
