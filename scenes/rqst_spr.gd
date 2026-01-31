extends Sprite2D




@onready var argile: Sprite2D = $"../../argile"

var argile0_texture = preload("res://sprites/argile/argile0.png")

var pots = {
	"pot1": [["up", "down"], ["up", "up", "down"]],
	"pot2": [["left", "right"], ["right", "left"]],
	"pot3": [["up", "up"], ["down", "down"]],
	"pot4": [["left", "up"], ["up", "left"]],
	"pot5": [["down", "down"], ["up", "down"]]
}

var current_pot := ""        
var player_sequence := []    

func _ready():
	if argile:
		argile.texture = argile0_texture
	randomize()
	pick_random_pot()

func pick_random_pot():
	var keys = pots.keys()
	var new_pot = current_pot

	while new_pot == current_pot and keys.size() > 1:
		new_pot = keys[randi() % keys.size()]

	current_pot = new_pot
	player_sequence.clear()

	self.texture = load("res://sprites/pots/%s.png" % current_pot)
	print("ok fait :", current_pot, pots[current_pot])

func register_input(dir: String) -> String:
	if player_sequence.size() == 0:
		if argile.texture.resource_path != argile0_texture.resource_path:
			print("nn reommence")
			return "continue"
	
	player_sequence.append(dir)
	if check_sequence():
		return "success"
	else:
		return "continue"

func check_sequence() -> bool:
	#var i = player_sequence.size() - 1
	var combos = pots[current_pot]  
	for seq in combos:
		if player_sequence == seq:
			return true
	return false



func success():
	print("gg ")
	var seq = player_sequence
	var sequence_name = "".join(seq) 
	var path = "res://sprites/argile/argile_%s.png" % sequence_name
	
	if ResourceLoader.exists(path):
		argile.texture = load(path)
	




func fail():
	print("nn mdr")
	#player_sequence.clear()
	#argile.texture = argile0_texture
	
func undo_sequence():
	if player_sequence.size() > 0:
		player_sequence.pop_back()


func _on_clear_pressed() -> void:
	player_sequence.clear()


func _on_finish_pressed() -> void:
	if check_sequence():
		success()
		
		GameManager.argile_texture = argile.texture
		GameManager.pot_demande = self.texture
		
		await get_tree().create_timer(2.0).timeout
		get_tree().change_scene_to_file("res://scenes/oven.tscn")
	else:
		fail()
		print("et nannn")
