class_name SmudgeEraser
extends Tool


var is_clicked: bool = false
var prev_mouse_position: Vector2

func _init(canvas: Image) -> void:
	super._init(canvas)
	color = Color.TRANSPARENT
	tool_size = 5
	sprite.texture = load("res://assets/tools/button13.png")


func _unhandled_input(event) -> void:
	if event is InputEventMouseButton:
		if event.get_button_index() == MOUSE_BUTTON_LEFT:
			if event.pressed:
				is_clicked = true
				prev_mouse_position = event.position.round()
				
				_gauss_blur_point_zone(prev_mouse_position.x, prev_mouse_position.y, tool_size)
				draw_pixels(edited_pixels)
			else:
				is_clicked = false
	elif event is InputEventMouseMotion and is_clicked:
		var brushPosition = prev_mouse_position
		var smearDirection: Vector2 = (event.position - brushPosition).normalized() * 20
		var theta : float = randf() * 2 * PI
		var startPosition = (brushPosition + Vector2(cos(theta), sin(theta)) * sqrt(randf()) * 20).round()
		startPosition.x = clamp(startPosition.x, 0, canvas_ref.get_width() - 1)
		startPosition.y = clamp(startPosition.y, 0, canvas_ref.get_height() - 1)
		var midPosition = startPosition
		var endPosition = startPosition + smearDirection
		var canvas_color = canvas_ref.get_pixelv(startPosition)
		while (brushPosition - event.position).length() > 0.0:
			_gauss_blur_point_zone(brushPosition.round().x, brushPosition.round().y, tool_size)
			brushPosition = brushPosition.move_toward(event.position, 1)
		draw_pixels(edited_pixels)
		prev_mouse_position = event.position


func _gauss_blur_point_zone(x:int, y:int, r:int) -> void:
	var viewport_size = get_viewport_rect().size
	if x < 0 and x > viewport_size.x and y < 0 and y > viewport_size.y: return
	var center_pixel_color = canvas_ref.get_pixel(x,y)
	var avg_r = 0
	var avg_g = 0
	var avg_b = 0
	var avg_a = 0
	for i in range(max(x-r, 0), min(x+r, viewport_size.x)):
		for j in range(max(y-r, 0), min(y+r, viewport_size.y)):
			var near_color = canvas_ref.get_pixel(i,j)
			avg_r += near_color.r
			avg_g += near_color.g
			avg_b += near_color.b
			avg_a += near_color.a
	
	var sq = r*r
	center_pixel_color.r = avg_r / sq
	center_pixel_color.g = avg_g / sq
	center_pixel_color.b = avg_b / sq
	center_pixel_color.a = avg_a / sq
	edited_pixels[Vector2i(x, y)] = center_pixel_color