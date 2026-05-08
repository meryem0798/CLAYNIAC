extends Control

@onready var slider: HSlider = $HSlider



func _ready():
	var saved := load_volume()
	slider.value = saved 
	
func _on_h_slider_value_changed(value: float) -> void:
	var bus := AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))
	save_volume(value)
	#$"../8BitGame2186976".play()


func save_volume(value: float) -> void:
	var file := FileAccess.open("user://volume.save", FileAccess.WRITE)
	file.store_float(value)

func load_volume() -> float:
	if FileAccess.file_exists("user://volume.save"):
		var file := FileAccess.open("user://volume.save", FileAccess.READ)
		return file.get_float()

	return 1.0
