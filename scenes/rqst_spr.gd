extends Sprite2D

@onready var argile: Sprite2D = $"../../argile"
var argile0_texture = preload("res://sprites/argile/argile0.png")


@onready var dialogue_ui: Control = $"../../DialogUI"
@onready var continueicon: AnimatedSprite2D = $"../../continueicon"
@onready var undo: Button = $"../../undo"
@onready var clear: Button = $"../../clear"
@onready var btn_up: Button = $"../../btn_up"
@onready var btn_left: Button = $"../../btn_left"
@onready var btn_right: Button = $"../../btn_right"
@onready var btn_down: Button = $"../../btn_down"
@onready var finish: Button = $"../../finish"
@onready var help: Button = $"../../help"

var pots = {
	"pot1": [["up", "down"], ["up", "up", "down", "down", "down"]],
	"pot2": [["up", "up", "left", "right", "down"], ["right", "left", "up", "up", "down"]],
	"pot3": [["down", "down", "left", "right"], ["down", "down", "right", "left"]],
	"pot4": [["up", "left", "left", "right", "down"]],
	"pot5": [["up", "left", "left", "right", "down"]],
	"pot6": [["up", "up", "down"]],
	"pot7": [["down", "down", "down"]],
	"pot8": [["up", "down"]],
	"pot9": [["up", "right", "right", "down"]],
	"pot10": [["up", "right", "right", "down"]]
}

var current_pot := ""
var player_sequence := []

func _ready():
	finish.visible = false
	randomize()
	pick_random_pot()
	
	await get_tree().process_frame
	dialogue_ui.start(get_dialogue_key())
	

func pick_random_pot():
	var keys = pots.keys()
	current_pot = keys[randi() % keys.size()]
	player_sequence.clear()
	self.texture = load("res://sprites/pots/%s.png" % current_pot)
	print(current_pot, pots[current_pot])

func register_input(dir: String) -> String:
	player_sequence.append(dir)
	if check_sequence():
		return "success"
	return "continue"
	
func get_dialogue_key() -> String:
	return "diao_" + current_pot 

func get_current_pot_name() -> String:
	return current_pot 

func check_sequence() -> bool:
	var combos = pots[current_pot]
	for seq in combos:
		if player_sequence == seq: 
			dialogue_ui.visible = false
			finish.visible = true
			continueicon.visible = true
			undo.disabled = true
			clear.disabled = true
			help.disabled = true
			return true
	return false

func undo_sequence():
	if player_sequence.size() > 0:
		player_sequence.pop_back()

func _on_finish_pressed() -> void:
	if check_sequence():
		GameManager.argile_texture = argile.texture 
		GameManager.pot_demande = self.texture
		finish.visible = true
		
		Transition.fade_to_scene("res://scenes/stamps.tscn")
	else:
		finish.visible = false
		print("pasfini")


func _on_help_pressed() -> void:
	if dialogue_ui.visible:
		return

	var key = get_dialogue_key()
	dialogue_ui.start(key)
