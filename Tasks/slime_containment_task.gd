extends Node2D

var main #instantiated in ready
var state = false #game state, 
var goalState = null #the target state, initialized when task is added to task board

var NAMES = []
static var available_names = []

var task_name = ""

var info = {}



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
	
	var id = get_parent().get_parent().get_parent().get_parent().get_ID()
	info["color"] = id.x
	info["index"] = id.y
	info["type"] = "Slime Containment"
	
	info["state"] = state
	info["Vinfo1"] = $Valve1.get_info()
	info["Vinfo2"] = $Valve2.get_info()
	info["Vinfo3"] = $Valve3.get_info()
	info["Vinfo4"] = $Valve4.get_info()
	info["Vinfo5"] = $Valve5.get_info()

func get_location_sprite():
	return "slime"

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
	
	update_info()
	main.get_node("Multiplayer_Tasks").send_process_update_task(info)
	
	return "Slime stuff"

func update_info():
	info["state"] = state
	info["Vinfo1"] = $Valve1.get_info()
	info["Vinfo2"] = $Valve2.get_info()
	info["Vinfo3"] = $Valve3.get_info()
	info["Vinfo4"] = $Valve4.get_info()
	info["Vinfo5"] = $Valve5.get_info()
	

func update_task(info):
	if info["type"] == "Slime Containment":
		state = info["state"]
		$Valve1.update_info(info["Vinfo1"])
		$Valve2.update_info(info["Vinfo2"])
		$Valve3.update_info(info["Vinfo3"])
		$Valve4.update_info(info["Vinfo4"])
		$Valve5.update_info(info["Vinfo5"])
		if main.my_ID == 1:
			if goalState == state:
				goalState = null
				state = false
				main.currMap.task_board.task_completed(get_parent().get_parent().get_parent().get_parent().ID)

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
	
	update_info()
	main.get_node("Multiplayer_Tasks").send_process_update_task(info)
	state = false


func override():
	state = true
	update_info()
	main.get_node("Multiplayer_Tasks").send_process_update_task(info)
