extends Sprite2D

var pots = {
	"pot1": ["up", "down"],
	"pot2": ["left", "right"],
	"pot3": ["up", "up"],
	"pot4": ["left", "up"],
	"pot5": ["down", "down"]
}

var current_pot := ""
var pot_sequence := []
var player_sequence := []


func _ready():
	randomize()
	pick_random_pot()


func pick_random_pot():
	var keys = pots.keys()
	var new_pot = current_pot 

	while new_pot == current_pot and keys.size() > 1:
		new_pot = keys[randi() % keys.size()]
	
	current_pot = new_pot
	pot_sequence = pots[current_pot]
	player_sequence.clear()

	texture = load("res://sprites/pots/%s.png" % current_pot)
	print("pot:", current_pot, pot_sequence)


func register_input(dir: String) -> String: 
	player_sequence.append(dir)
	return check_sequence() 

func check_sequence() -> String:
	var i := player_sequence.size() - 1

	if player_sequence[i] != pot_sequence[i]:
		fail()
		return "fail"

	if player_sequence.size() == pot_sequence.size():
		success()
		return "success"
	
	return "continue" 

func success():
	print("yessss gg mec", current_pot)
	pick_random_pot()


func fail():
	print("mdrnn")
	player_sequence.clear()
