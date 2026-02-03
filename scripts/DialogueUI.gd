extends Control


@onready var label: Label = $DialogueLabel

var typing_speed := 0.03
var is_typing := false
var full_text := ""

func _ready():
	hide()

func start(key: String):
	if visible:
		return 

	DialoguzManager.start_dialogue(key)
	show()
	next_line()

func next_line():
	if is_typing:
		label.text = full_text
		is_typing = false
		return

	var line = DialoguzManager.get_next_line()
	if line == "":
		close()
		return

	type_text(line)


func type_text(text: String):
	label.text = ""
	full_text = text
	is_typing = true

	for i in range(text.length()):
		if not is_typing:
			break
		label.text += text[i]
		await get_tree().create_timer(typing_speed).timeout

	is_typing = false


func close():
	hide()
	

func _input(event):
	if not visible:
		return
	if event.is_action_pressed("ui_accept"):
		next_line()
