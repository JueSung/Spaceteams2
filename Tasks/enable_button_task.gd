extends Node2D
class_name Enabled_Button_Task

var main #instantiated in ready
var state = false #game state, enabled or not
var goalState = null #the target state, initialized when task is added to task board

var NAMES = []
static var available_names = []

func _ready():
	
	main = get_tree().root.get_node("Main")

#called by assigned task_location object
func open():
	pass

func close():
	pass

#is being assigned a goal by task_board so set a goalState prob to what state it is not
func make_goal():
	goalState = not state
	if goalState:
		return "Enable Something Button"
	else:
		return "Disable Something Button"

func button_pressed():
	state = not state
	if state:
		print("Enabled!")
	else:
		print("Disabled!")
	#first elem vector2 of id, second is state
	main.get_node("Multiplayer_Tasks").send_update_task([get_parent().get_parent().get_ID(), state])

#updates the task in server called by update_task in multiplayer_tasks
#also called by clients from server then sending info out to clients
func update_task(info):
	state = info[1]
	if main.my_ID == 1:
		if goalState == state:
			goalState = null
			main.currMap.task_board.task_completed(get_parent().get_parent().ID)
	
