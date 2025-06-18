extends Node2D
class_name Waste1
#Shred Trash


var main #instantiated in ready
var state = 0 #game state, enabled or not
var goalState = null #the target state, initialized when task is added to task board

var NAMES = []
static var available_names = []

var task_name = "Shred Waste"


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
	main.get_node("Multiplayer_Tasks").send_update_task([get_parent().get_parent().get_ID(), state])

func update_task(info):
	state = info[1]
	
	if main.my_ID == 1 and goalState == state:
		goalState = null
		$Mouse_Blocker.visible = true
		main.currMap.task_board.task_completed(get_parent().get_parent().ID)

func override():
	if goalState:
		state = 50
		main.get_node("Multiplayer_Tasks").send_update_task([get_parent().get_parent().get_ID(), state])
