extends Node2D
@onready var paint: AnimatedSprite2D = $paint

@onready var argilelol: Sprite2D = $argilelol
#@onready var color_picker: ColorPickerButton = $ColorPickerButton
#@onready var area_2d: Area2D = $Area2D
@onready var rqst_spr_3: Sprite2D = $rqst_spr3
#@onready var area_2d: Area2D = $Area2D_Pot1
var allowed_colors : Array[Color] = [
	Color("dce8e8"), 
	Color("d4d7d2") 
]
var draw_image: Image
var draw_texture: ImageTexture
var brush_color: Color = Color("3e8091")
var brush_size: int = 3
var last_mouse_pos: Vector2 = Vector2.ZERO
@onready var paper: AudioStreamPlayer2D = $paper

var original_image: Image
var is_erasing: bool = false
@onready var home: AnimatedSprite2D = $home
@onready var knock: AudioStreamPlayer2D = $knock
@onready var smallicon: AnimatedSprite2D = $smallicon
@onready var mediumicon: AnimatedSprite2D = $mediumicon
@onready var bigicon: AnimatedSprite2D = $bigicon
@onready var erasericon: AnimatedSprite2D = $erasericon
@onready var finishbutton: AnimatedSprite2D = $finishbutton
@onready var paintsound: AudioStreamPlayer2D = $paintsound
@onready var boing: AudioStreamPlayer2D = $boing


func _ready():
	MusicPlayer.play_music(preload("res://music/little_cafe.wav"))
	rqst_spr_3.texture = GameManager.pot_demande
	if GameManager.pot_demande:
		GameManager._update_pot_id() 
	
	var id = GameManager.pot_id

	argilelol.texture = GameManager.pot_demande


	var ref_image = GameManager.pot_demande.get_image()
	ref_image.convert(Image.FORMAT_RGBA8)
	original_image = ref_image 


	var temp_image = argilelol.texture.get_image()
	temp_image.convert(Image.FORMAT_RGBA8)
	draw_image = temp_image
	draw_texture = ImageTexture.create_from_image(draw_image)
	argilelol.texture = draw_texture
	
	
func is_color_allowed(pixel_color: Color) -> bool:
	for allowed in allowed_colors:
		if pixel_color.is_equal_approx(allowed):
			return true
	return false
	
	
func _input(event: InputEvent) -> void:
	if not is_mouse_in_area():
		last_mouse_pos = Vector2.ZERO
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				var local_pos = get_local_mouse_pos_on_sprite()
				last_mouse_pos = local_pos
				draw_point(local_pos)
			else:
				last_mouse_pos = Vector2.ZERO

	if event is InputEventMouseMotion and event.button_mask & MOUSE_BUTTON_MASK_LEFT:
		var local_pos = get_local_mouse_pos_on_sprite()
		if last_mouse_pos != Vector2.ZERO:
			draw_line_segmented(last_mouse_pos, local_pos)
			last_mouse_pos = local_pos

func is_mouse_in_area() -> bool:
	var local_pos = get_local_mouse_pos_on_sprite()
	var x = int(local_pos.x)
	var y = int(local_pos.y)
	
	if x < 0 or x >= original_image.get_width() or y < 0 or y >= original_image.get_height():
		return false
		
	var pixel_color = original_image.get_pixel(x, y)
	

	return pixel_color.a > 0.1 and is_color_allowed(pixel_color)

func get_local_mouse_pos_on_sprite() -> Vector2:
	var rect = argilelol.get_rect()
	return argilelol.to_local(get_global_mouse_position()) + rect.size / 2

func draw_point(pos: Vector2):
	var x = int(pos.x)
	var y = int(pos.y)
	var half_size = brush_size / 2
	
	for i in range(-half_size, half_size + 1):
		for j in range(-half_size, half_size + 1):
			var px = x + i
			var py = y + j
			
			if px >= 0 and px < draw_image.get_width() and py >= 0 and py < draw_image.get_height():
				var original_pixel_color = original_image.get_pixel(px, py)
				

				if is_color_allowed(original_pixel_color):
					if is_erasing:
						draw_image.set_pixel(px, py, original_pixel_color)
					else:
						draw_image.set_pixel(px, py, brush_color)
	
	draw_texture.update(draw_image)

func draw_line_segmented(from: Vector2, to: Vector2):
	var distance = from.distance_to(to)
	var steps = max(distance / 2.0, 1)
	for s in range(steps):
		var lerp_pos = from.lerp(to, float(s) / steps)
		draw_point(lerp_pos)

func _on_color_picker_button_color_changed(color: Color) -> void:
	brush_color = color


func _on_done_pressed() -> void:
	#paper.play()
	GameManager.argile_texture = argilelol.texture
	get_tree().change_scene_to_file("res://scenes/final.tscn")


func _on_brush_pressed() -> void:
	paintsound.play()
	brush_color = Color("3e8091")
	brush_size = 3
	is_erasing = false
	#argilelol.self_modulate = color_picker.color
	print("paint test")


func _on_eraser_pressed() -> void:
	boing.play()
	is_erasing = true
	print("gomme test")


func _on_small_pressed() -> void:
	brush_size = 1


func _on_medium_pressed() -> void:
	brush_size = 3


func _on_big_pressed() -> void:
	brush_size = 5


func _on_mainmenu_pressed() -> void:
	knock.play()
	Transition.fade_to_scene("res://scenes/mainmenu.tscn")

func _on_mainmenu_mouse_entered() -> void:
	home.play("pressed")


func _on_mainmenu_mouse_exited() -> void:
	home.play("default")


func _on_brush_mouse_entered() -> void:
	paint.play("pressed")


func _on_brush_mouse_exited() -> void:
	paint.play("default")


func _on_small_mouse_entered() -> void:
	smallicon.play("pressed")


func _on_small_mouse_exited() -> void:
	smallicon.play("default")


func _on_medium_mouse_entered() -> void:
	mediumicon.play("pressed")


func _on_medium_mouse_exited() -> void:
	mediumicon.play("default")


func _on_big_mouse_entered() -> void:
	bigicon.play("pressed")


func _on_big_mouse_exited() -> void:
	bigicon.play("default")


func _on_eraser_mouse_entered() -> void:
	erasericon.play("pressed")


func _on_eraser_mouse_exited() -> void:
	erasericon.play("default")


func _on_done_mouse_entered() -> void:
	finishbutton.play("pressed")


func _on_done_mouse_exited() -> void:
	finishbutton.play("default")
