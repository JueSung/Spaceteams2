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

##func _input(event):
##	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
##		if not event.pressed:
##			dragging = false
##			print("RAN")

func _process(delta):
	if dragging:
		global_position.x = get_global_mouse_position().x - offset.x
