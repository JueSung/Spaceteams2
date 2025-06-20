extends Area2D
class_name Slime_Level

var target_pos_y = 650 #100 to 650 is the y axis range

var SPEED = 100

var TOLERANCE = 5

func _ready():
	global_position.y = 650
	

#10 full rotations equals full distance
#10 * 2pi * radius (radians) * factor = 550 (linear distance in pixels)
func update_target_pos(delta_rot):
	#print("D", delta_rot)
	#print(delta_rot * 550.0 / 10 / 2 / PI)
	target_pos_y -= delta_rot * 550.0 / 10 / 2 / PI
	
	if target_pos_y > 650:
		target_pos_y = 650
	elif target_pos_y < 100:
		target_pos_y = 100
	#print(target_pos_y)

func _process(delta):
	#print(target_pos_y - global_position.y)
	#print("T", target_pos_y)
	#print("G", global_position.y)
	if target_pos_y - global_position.y > TOLERANCE:
		global_position.y += SPEED * delta
	elif target_pos_y - global_position.y < -1 * TOLERANCE:
		global_position.y -= SPEED * delta
	
	if global_position.y > 650:
		global_position.y = 650
	elif global_position.y < 100:
		global_position.y = 100
