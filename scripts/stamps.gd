extends Node2D

@onready var argilelol: Sprite2D = $argilelol
@onready var rqst_spr_3: Sprite2D = $rqst_spr3

@onready var done: Button = $done
@onready var trash: Button = $trash

@onready var ch_pressed: Sprite2D = $ch_pressed
@onready var st_pressed: Sprite2D = $st1_pressed
@onready var w_pressed: Sprite2D = $w1_pressed

@onready var ch_1: Sprite2D = $ch1
@onready var st_1: Sprite2D = $st1
@onready var w_1: Sprite2D = $w1
@onready var deletestamp: AnimatedSprite2D = $deletestamp
@onready var continueicon: AnimatedSprite2D = $continueicon
@onready var knock: AudioStreamPlayer2D = $knock
@onready var home: AnimatedSprite2D = $home
@onready var stampsound: AudioStreamPlayer2D = $stampsound
@onready var boing: AudioStreamPlayer2D = $boing

var right: bool = false


const POTS_AVEC_STAMPS := [4, 5, 8, 10]

func _ready():
	continueicon.visible = false
	MusicPlayer.play_music(preload("res://music/little_cafe.wav"))


	ch_1.visible = true
	st_1.visible = true
	w_1.visible = true
	ch_pressed.visible = false
	st_pressed.visible = false
	w_pressed.visible = false


	rqst_spr_3.texture = GameManager.pot_demande
	if GameManager.pot_demande:
		GameManager._update_pot_id()

	var id = GameManager.pot_id
	print(id)


	right = not id in POTS_AVEC_STAMPS
	update_done_visibility()


	load_pot_texture("_blank")



func update_done_visibility():
	done.visible = right
	continueicon.visible = right



func apply_pot_variant(suffix: String) -> void:
	var id = GameManager.pot_id
	var path = "res://sprites/pots/pot" + str(id) + "_" + suffix + ".png"
	var texture = load(path)
	if texture:
		argilelol.texture = texture
	else:
		print("Erreur : texture introuvable", path)

func apply_stamp(type: String) -> void:
	match type:
		"checker":
			apply_pot_variant("checker")
		"stripes":
			apply_pot_variant("ridges")
		"waves":
			apply_pot_variant("waves")

	var id = GameManager.pot_id
	right = false
	match id:
		4:
			right = type == "checker"
		5:
			right = type == "stripes"
		8, 10:
			right = type == "waves"

	update_done_visibility()

func load_pot_texture(suffix: String) -> void:
	var id = GameManager.pot_id
	var path = "res://sprites/pots/pot" + str(id) + suffix + ".png"
	var texture = load(path)
	if texture:
		argilelol.texture = texture
	else:
		print(path)


func _on_checker_pressed() -> void:
	stampsound.play()
	apply_stamp("checker")

func _on_stripes_pressed() -> void:
	stampsound.play()
	apply_stamp("stripes")

func _on_waves_pressed() -> void:
	stampsound.play()
	apply_stamp("waves")



func _on_done_pressed() -> void:
	if not right:
		return
	trash.visible = false
	Transition.fade_to_scene("res://scenes/oven.tscn")



func _on_trash_pressed() -> void:
	boing.play()
	load_pot_texture("_blank")
	var id = GameManager.pot_id
	right = not id in POTS_AVEC_STAMPS
	update_done_visibility()


func _on_checker_mouse_entered() -> void:
	ch_1.visible = false
	ch_pressed.visible = true

func _on_checker_mouse_exited() -> void:
	ch_1.visible = true
	ch_pressed.visible = false

func _on_stripes_mouse_entered() -> void:
	st_1.visible = false
	st_pressed.visible = true

func _on_stripes_mouse_exited() -> void:
	st_1.visible = true
	st_pressed.visible = false

func _on_waves_mouse_entered() -> void:
	w_1.visible = false
	w_pressed.visible = true

func _on_waves_mouse_exited() -> void:
	w_1.visible = true
	w_pressed.visible = false

func _on_trash_mouse_entered() -> void:
	deletestamp.play("pressed")

func _on_trash_mouse_exited() -> void:
	deletestamp.play("default")

func _on_done_mouse_entered() -> void:
	continueicon.play("pressed")

func _on_done_mouse_exited() -> void:
	continueicon.play("default")


func _on_mainmenu_pressed() -> void:
	knock.play()
	Transition.fade_to_scene("res://scenes/mainmenu.tscn")

func _on_mainmenu_mouse_entered() -> void:
	home.play("pressed")

func _on_mainmenu_mouse_exited() -> void:
	home.play("default")
