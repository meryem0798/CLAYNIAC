extends Node
class_name DialogueManager

var dialogue := {}
var current_lines: Array = []
var index := 0

func _ready():
	load_dialogue()

func load_dialogue():
	var file = FileAccess.open("res://dialogues/dialogs.json", FileAccess.READ)
	if file:
		dialogue = JSON.parse_string(file.get_as_text())
	else:
		push_error("Dialogue JSON not found")

func start_dialogue(key: String):
	if dialogue.has(key):
		current_lines = dialogue[key]
		index = 0
	else:
		current_lines = []
		index = 0

func get_next_line() -> String:
	if index >= current_lines.size():
		return ""
	var line = current_lines[index]
	index += 1
	return line
