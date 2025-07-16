extends Node2D
class_name Waste1
#Shred Trash


var main #instantiated in ready
var state = 0 #game state, enabled or not
var goalState = null #the target state, initialized when task is added to task board

var NAMES = []
static var available_names = []

var task_name = "Shred Waste"

var info = {}


func setUp():
	if len(available_names) == 0:
		return false
	randomize()
	var ind = int(randf_range(0, len(available_names)))
	task_name = available_names[ind]
	available_names.pop_at(ind)

func _ready():
	main = get_tree().root.get_node("Main")
	
	$Mouse_Blocker.visible = true
	
	var id = get_parent().get_parent().get_ID()
	info["color"] = id.x
	info["index"] = id.y
	info["type"] = "Waste Task 1"
	
	info["state"] = state

func get_location_sprite():
	return "waste1"

func open():
	if goalState != null:
		$Mouse_Blocker.visible = false

func close():
	$Mouse_Blocker.visible = true

func make_goal():
	goalState = 50
	return "Shred Trash"

func button_pressed():
	state += 1
	if state == goalState:
		$Mouse_Blocker.visible = true
	update_info()
	main.get_node("Multiplayer_Tasks").send_update_task(info)

func update_info():
	info["state"] = state

func update_task(info):
	if info["type"] == "Waste Task 1":
		state = info["state"]
		
		if main.my_ID == 1 and goalState == state:
			goalState = null
			$Mouse_Blocker.visible = true
			main.currMap.task_board.task_completed(get_parent().get_parent().ID)

func override():
	if goalState:
		state = 50
		update_info()
		main.get_node("Multiplayer_Tasks").send_update_task(info)
