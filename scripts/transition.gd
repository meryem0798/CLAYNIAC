extends CanvasLayer
class_name SceneTransition

@onready var anim: AnimationPlayer = $AnimationPlayer

var next_scene_path := ""

func _ready():
	anim.play("nothing")

func fade_to_scene(path: String):
	next_scene_path = path
	anim.play("fade_out")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		get_tree().change_scene_to_file(next_scene_path)
		anim.play("fade_in")
