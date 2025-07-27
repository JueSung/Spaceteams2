extends Area2D


var dragging = false
var offset = Vector2(0,0)

var is_aligned = false #for sprite stuff


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

#called by align_crystal check every frame if aligned, if so, set to secondary sprite so glow, if not then no
func set_aligned(yn):
	if yn and not is_aligned:
		is_aligned = true
		$Sprite2D.visible = false
		$Sprite2D_glow.visible = true
	elif not yn and is_aligned:
		is_aligned = false
		$Sprite2D.visible = true
		$Sprite2D_glow.visible = false
		
func get_aligned():
	return is_aligned

func _process(delta):
	if dragging:
		global_position.x = get_global_mouse_position().x - offset.x
		if global_position.x < 500:
			global_position.x = 500
		elif global_position.x > 1420:
			global_position.x = 1420
