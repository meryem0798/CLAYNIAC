extends Node2D
@onready var rqst_spr_2: Sprite2D = $rqst_spr2
@onready var slider: Control = $slider
@onready var home: AnimatedSprite2D = $home
@onready var knock: AudioStreamPlayer2D = $knock
@onready var firebutton: AnimatedSprite2D = $firebutton
@onready var wood: AudioStreamPlayer2D = $wood

func _ready() -> void:
	rqst_spr_2.texture = GameManager.pot_demande
	MusicPlayer.play_music(preload("res://music/little_cafe.wav"))

		
		
func _on_button_pressed() -> void:
	wood.play()
	#play sound
	#play oven animation
	
	#await get_tree().create_timer(2.0).timeout
	#get_tree().change_scene_to_file("res://scenes/paint.tscn")



func _on_mainmenu_pressed() -> void:
	knock.play()
	Transition.fade_to_scene("res://scenes/mainmenu.tscn")


func _on_mainmenu_mouse_entered() -> void:
	home.play("pressed")


func _on_mainmenu_mouse_exited() -> void:
	home.play("default")


func _on_button_mouse_entered() -> void:
	firebutton.play("pressed")


func _on_button_mouse_exited() -> void:
	firebutton.play("default")
