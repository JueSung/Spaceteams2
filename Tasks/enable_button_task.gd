extends Node2D
class_name Enabled_Button_Task

var main #instantiated in ready
var enabled = false #game state, enabled or not

func _ready():
	
	main = get_tree().root.get_node("Main")

#called by assigned task_location object
func open():
	pass


func button_pressed():
	enabled = not enabled
	if enabled:
		print("Enabled!")
	else:
		print("Disabled!")
