extends Node2D

@onready var argilelol: Sprite2D = $argilelol
@onready var color_picker: ColorPickerButton = $ColorPickerButton
@onready var area_2d: Area2D = $Area2D
@onready var rqst_spr_3: Sprite2D = $rqst_spr3

var draw_image: Image
var draw_texture: ImageTexture
var brush_color: Color = Color.BLACK
var brush_size: int = 3
var last_mouse_pos: Vector2 = Vector2.ZERO

var original_image: Image
var is_erasing: bool = false

func _ready():
	rqst_spr_3.texture = GameManager.pot_demande
	if GameManager.argile_texture: #je vais me tuer pq il fallait que je vérifie si l'e potargile' existe pr que ça marche????????
		argilelol.texture = GameManager.argile_texture


	var temp_image = argilelol.texture.get_image()
	temp_image.convert(Image.FORMAT_RGBA8) 
	original_image = temp_image.duplicate()
	
	draw_image = temp_image
	draw_texture = ImageTexture.create_from_image(draw_image)
	argilelol.texture = draw_texture
	
	
	
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
	var mouse_pos = get_global_mouse_position()
	
	var query = PhysicsPointQueryParameters2D.new()
	query.position = mouse_pos
	query.collide_with_areas = true

	
	var results = get_world_2d().direct_space_state.intersect_point(query)
	
	for res in results:
		if res.collider == area_2d:
			return true
	return false

func get_local_mouse_pos_on_sprite() -> Vector2:
	var rect = argilelol.get_rect()
	return argilelol.to_local(get_global_mouse_position()) + rect.size / 2

func draw_point(pos: Vector2):
	var x = int(pos.x)
	var y = int(pos.y)
	var half_size = brush_size / 2
	
	if is_erasing:
		for i in range(-half_size, half_size):
			for j in range(-half_size, half_size):
				var px = x + i 
				var py = y + j
				
				if px >= 0 and px < draw_image.get_width() and py >= 0 and py < draw_image.get_height():
					var original_pixel = original_image.get_pixel(px, py)
					draw_image.set_pixel(px, py, original_pixel)
	else:
		var rect = Rect2i(x - half_size, y - half_size, brush_size, brush_size)
		draw_image.fill_rect(rect, brush_color)
	
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
	GameManager.argile_texture = argilelol.texture
	get_tree().change_scene_to_file("res://scenes/final.tscn")


func _on_brush_pressed() -> void:
	is_erasing = false
	print("paint test")


func _on_eraser_pressed() -> void:
	is_erasing = true
	print("gomme test")


func _on_small_pressed() -> void:
	brush_size = 2


func _on_medium_pressed() -> void:
	brush_size = 3


func _on_big_pressed() -> void:
	brush_size = 5
