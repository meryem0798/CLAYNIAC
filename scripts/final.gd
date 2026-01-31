extends Node2D
@onready var argilelol_2: Sprite2D = $argilelol2


func _ready():
	if GameManager.argile_texture:
		argilelol_2.texture = GameManager.argile_texture
	else:
		print("nn")
