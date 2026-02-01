extends Node

var argile_texture: Texture2D
var pot_demande: Texture2D
var pot_id: int = -1

func set_pot_demande(texture: Texture2D) -> void:
	pot_demande = texture
	_update_pot_id()

func _update_pot_id() -> void:
	if pot_demande == null:
		pot_id = -1
		return

	var file := pot_demande.resource_path.get_file()

	var pots := {
		"pot1.png": 1,
		"pot2.png": 2,
		"pot3.png": 3,
		"pot4.png": 4,
		"pot5.png": 5,
		"pot6.png": 6,
		"pot7.png": 7,
		"pot8.png": 8,
		"pot9.png": 9,
		"pot10.png": 10
	}

	pot_id = pots.get(file, -1)
