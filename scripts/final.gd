extends Node2D

@onready var argilelol_2: Sprite2D = $argilelol2
@onready var rqst_spr_3: Sprite2D = $rqst_spr3
@onready var truc: Sprite2D = $truc

const SLIDE_DISTANCE := 700
const ANTICIPATION := 20
const BOUNCE := 10

const ANTICIPATION_TIME := 0.15
const BOUNCE_TIME := 0.18
const SLIDE_TIME := 0.60
@onready var home: AnimatedSprite2D = $home
@onready var knock: AudioStreamPlayer2D = $knock
@onready var continueicon: AnimatedSprite2D = $continueicon

func _ready():
	MusicPlayer.play_music(preload("res://music/little_cafe.wav"))
	rqst_spr_3.texture = GameManager.pot_demande
	if GameManager.pot_demande:
		GameManager._update_pot_id()
	if GameManager.argile_texture:
		argilelol_2.texture = GameManager.argile_texture
	else:
		print("nn")

func slide_sprites(direction: int) -> void:
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)

	var start_argile_x := argilelol_2.position.x
	var start_truc_x := truc.position.x


	tween.tween_property(
		argilelol_2,
		"position:x",
		start_argile_x - ANTICIPATION * direction,
		ANTICIPATION_TIME
	)
	tween.parallel().tween_property(
		truc,
		"position:x",
		start_truc_x + ANTICIPATION * direction,
		ANTICIPATION_TIME
	)


	tween.tween_property(
		argilelol_2,
		"position:x",
		start_argile_x + BOUNCE * direction,
		BOUNCE_TIME
	)
	tween.parallel().tween_property(
		truc,
		"position:x",
		start_truc_x - BOUNCE * direction,
		BOUNCE_TIME
	)


	tween.tween_property(
		argilelol_2,
		"position:x",
		start_argile_x + SLIDE_DISTANCE * direction,
		SLIDE_TIME
	)
	tween.parallel().tween_property(
		truc,
		"position:x",
		start_truc_x - SLIDE_DISTANCE * direction,
		SLIDE_TIME
	)

	await tween.finished

func _on_continue_pressed() -> void:
	await slide_sprites(1) 
	Transition.fade_to_scene("res://scenes/main.tscn")




func _on_mainmenu_2_pressed() -> void:
	knock.play()
	Transition.fade_to_scene("res://scenes/mainmenu.tscn")


func _on_mainmenu_2_mouse_entered() -> void:
	home.play("pressed")


func _on_mainmenu_2_mouse_exited() -> void:
	home.play("default")


func _on_continue_mouse_entered() -> void:
	continueicon.play("pressed")


func _on_continue_mouse_exited() -> void:
	continueicon.play("default")
