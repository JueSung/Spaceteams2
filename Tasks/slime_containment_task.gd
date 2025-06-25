extends Node2D

var main #instantiated in ready
var state = false #game state, 
var goalState = null #the target state, initialized when task is added to task board

var NAMES = []
static var available_names = []

var task_name = ""





func setUp():
	pass
	##if len(available_names) == 0:
	##	return false
	##randomize()
	##var ind = int(randf_range(0, len(available_names)))
	##task_name = available_names[ind]
	##available_names.pop_at(ind)

func _ready():
	main = get_tree().root.get_node("Main")
	
	

func open():
	$Valve1.open()
	$Valve2.open()
	$Valve3.open()
	$Valve4.open()
	$Valve5.open()

func close():
	$Valve1.close()
	$Valve2.close()
	$Valve3.close()
	$Valve4.close()
	$Valve5.close()

func make_goal():
	goalState = true
	randomize()
	$Valve1/RayCast2D.position.y = int(randf_range(100, 650))
	$Valve2/RayCast2D.position.y = int(randf_range(100, 650))
	$Valve3/RayCast2D.position.y = int(randf_range(100, 650))
	$Valve4/RayCast2D.position.y = int(randf_range(100, 650))
	$Valve5/RayCast2D.position.y = int(randf_range(100, 650))
	
	main.get_node("Multiplayer_Tasks").send_process_update_task([get_parent().get_parent().get_ID(), \
		"Slime Containment",state,\
		$Valve1.get_info(), $Valve2.get_info(), $Valve3.get_info(), $Valve4.get_info(), $Valve5.get_info()])
	
	return "Slime stuff"

func update_task(info):
	if info[1] == "Slime Containment":
		state = info[2]
		$Valve1.update_info(info[3])
		$Valve2.update_info(info[4])
		$Valve3.update_info(info[5])
		$Valve4.update_info(info[6])
		$Valve5.update_info(info[7])
		if main.my_ID == 1:
			if goalState == state:
				goalState = null
				state = false
				main.currMap.task_board.task_completed(get_parent().get_parent().ID)

func _on_control_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed == false:
			$Valve1/Valve.dragging = false
			$Valve2/Valve.dragging = false
			$Valve3/Valve.dragging = false
			$Valve4/Valve.dragging = false
			$Valve5/Valve.dragging = false

func _process(delta):
	if $Valve1/RayCast2D.is_colliding() and $Valve2/RayCast2D.is_colliding() and\
	$Valve3/RayCast2D.is_colliding() and $Valve4/RayCast2D.is_colliding() and\
	$Valve5/RayCast2D.is_colliding():
		state = true
	main.get_node("Multiplayer_Tasks").send_process_update_task([get_parent().get_parent().get_ID(), \
		"Slime Containment",state,\
		$Valve1.get_info(), $Valve2.get_info(), $Valve3.get_info(), $Valve4.get_info(), $Valve5.get_info()])
	state = false


func override():
	state = true
	main.get_node("Multiplayer_Tasks").send_process_update_task([get_parent().get_parent().get_ID(), \
		"Slime Containment",state,\
		$Valve1.get_info(), $Valve2.get_info(), $Valve3.get_info(), $Valve4.get_info(), $Valve5.get_info()])
