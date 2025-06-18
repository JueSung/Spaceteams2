extends Area2D

var dragging = false
var offset = Vector2(0,0)

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			offset = get_global_mouse_position() - global_position
		else:
			dragging = false

func _process(delta):
	if dragging:
		global_position.y = get_global_mouse_position().y - offset.y
		if global_position.y > 550:
			global_position.y = 550
		elif global_position.y < 200:
			global_position.y = 200
