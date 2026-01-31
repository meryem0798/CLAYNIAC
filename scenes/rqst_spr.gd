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
	return check_sequence()

func check_sequence() -> String:
	var i = player_sequence.size() - 1
	var combos = pots[current_pot]  

	var still_possible = false
	for seq in combos:
		if i < seq.size() and player_sequence[i] == seq[i]:
			still_possible = true
			break

	if not still_possible:
		fail()
		

	for seq in combos:
		if player_sequence == seq:
			success()
			return "success"

	return "continue"

func success():
	print("gg ")
	argile.texture = self.texture 
	argile.texture = argile0_texture
	pick_random_pot()

func fail():
	print("nn mdr")
	player_sequence.clear()
	#argile.texture = argile0_texture
