extends Node2D
@onready var rqst_spr_2: Sprite2D = $rqst_spr2

func _ready() -> void:
	rqst_spr_2.texture = GameManager.pot_demande

		
		
func _on_button_pressed() -> void:
	#play sound
	#play oven animation
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://scenes/paint.tscn")
	pass 
