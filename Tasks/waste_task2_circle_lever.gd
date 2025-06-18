extends Area2D

var dragging = false

var rotOffset

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			var dir = get_global_mouse_position() - global_position
			rotOffset = atan2(dir.y, dir.x) - rotation
		else:
			dragging = false

func _process(delta):
	if dragging:
		var dir = get_global_mouse_position() - global_position
		rotation = atan2(dir.y, dir.x) - rotOffset
