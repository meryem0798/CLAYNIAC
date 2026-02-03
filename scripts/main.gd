extends Node

@onready var dialog_manager = $DialogManager
@onready var dialogbox: TextureRect = $DialogManager/dialogbox
@onready var label: Label = $DialogManager/Label


func _ready():
	dialogbox.visible = false
