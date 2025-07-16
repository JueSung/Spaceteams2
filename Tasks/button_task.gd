extends Node2D
class_name Button_Task
#completely ran by client(s) and only vital/relavent info sent to server for game state processing

var main #instantiated in ready

func _ready():
	main = get_tree().root.get_node("Main")

func get_location_sprite():
	return "big_button"

#called by assigned task_location object
func open():
	pass

func close():
	pass

func set_availability(available):
	if available:
		$Mouse_blocker.visible = false
	else:
		$Mouse_blocker.visible = true


func bigButton():
	print("Big button pressed")
	main.get_node("Multiplayer_Tasks").bigButtonPressed()

func override():
	bigButton()
