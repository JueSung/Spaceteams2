extends Area2D

var dragging = false

var rotOffset = 0

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
		var rot = atan2(dir.y, dir.x)
		
		var delta_rot = rot - rotOffset - rotation
		while (delta_rot >= 2 * PI):
			delta_rot -= 2 * PI
		while (delta_rot <= -2 * PI):
			delta_rot += 2 * PI
		rotation = rot - rotOffset
		if delta_rot > PI:
			delta_rot = (2 * PI - delta_rot) * -1
		elif delta_rot < -PI:
			delta_rot = (2 * PI + delta_rot) * -1
		get_parent().get_node("Slime_Level").update_target_pos(delta_rot)
