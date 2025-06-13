extends Control
class_name TaskBoard

var main #instantiated in ready
var TES = preload("res://Tasks/task_board_element.tscn")

var taskBar = 0 #value is the progress to end depending on what main defines as task_bar_goal
var taskBarGoal = 0 #amount needed to be able to hit big button to go to next round

var task_locations

var tasks = [] #in order top to bottom

#if true, the remove_task doesn't create new tasks nor increments task bar, just deletes the items
var betweenRounds = false 

func _ready():
	main = get_tree().root.get_node("Main")
	task_locations = get_parent().get_parent().get_parent().task_locations
	randomize()

func set_between_rounds(br):
	betweenRounds = br

#called by probably map to set the task bar goal for each round
func set_task_bar_goal(tbg):
	taskBarGoal = tbg
	#reset task bar info
	taskBar = 0
	$Temp_Task_Bar.text = ""

#ran by server
func add_task():
	#choose a random task_location
	#sad form of do while loop
	var task_location
	var i
	var j
	while true:
		i = int(randf_range(0, len(task_locations)))
		j = int(randf_range(0, len(task_locations[i])))
		task_location = task_locations[i][j]
		if task_location.task.goalState == null:
			break
	var goal = task_location.task.make_goal() #goal is string to put on msg, later will be for which sprite ig
	match i:
		0:
			goal = "Pink: " + goal
		1:
			goal = "Blue: " + goal
		2:
			goal = "Yellow: " + goal
		3:
			goal = "Green: " + goal
	
	var elem = TES.instantiate()
	elem.get_node("Label").text = goal
	elem.set_task_ID(Vector2(i,j))
	$VBoxContainer.add_child(elem)
	tasks.append(elem)
	
	main.get_node("Multiplayer_Tasks").send_add_board_task(goal, Vector2(i,j))

#ran by server
#increment when task completed, decrement when task expires
#increment : +1, decrement : -1
func update_task_bar(crement):
	taskBar += crement
	if len($Temp_Task_Bar.text) > 0 and $Temp_Task_Bar.text[0] != "*":
		$Temp_Task_Bar.text = ""
	if crement > 0:
		$Temp_Task_Bar.text += "*"
	else:
		if taskBar != 0:
			$Temp_Task_Bar.text = $Temp_Task_Bar.text.substr(0, len($Temp_Task_Bar.text)-1)
	
	
	if taskBar <= 0:
		taskBar = 0
	if taskBar >= taskBarGoal:
		$Temp_Task_Bar.text = "PUSH THE BUTTON"
		main.task_bar_met()
	
	main.get_node("Multiplayer_Tasks").send_set_task_bar(taskBar, $Temp_Task_Bar.text)

#ran by clients to update task bar
func set_task_bar(taskBarr, text):
	taskBar = taskBarr
	$Temp_Task_Bar.text = text

#ran by clients adds task based on what server says to add
func client_add_task(goal, id):
	var elem = TES.instantiate()
	elem.get_node("Label").text = goal
	elem.set_task_ID(id)
	$VBoxContainer.add_child(elem)
	tasks.append(elem)

#called by assigned task_location object
func open():
	pass
func close():
	pass

func task_completed(id):
	for i in range(len(tasks)):
		if tasks[i].get_ID() == id:
			remove_task(i)
			break

func remove_task(index):
	var t = tasks.pop_at(index)
	t.queue_free()
	if main.my_ID == 1:
		main.get_node("Multiplayer_Tasks").send_remove_board_task(index)
		if not betweenRounds:
			add_task()
			update_task_bar(1)
	
#override button
func do_a_thing() -> void:
	task_locations[tasks[0].get_ID().x][tasks[0].get_ID().y].task.state = \
	task_locations[tasks[0].get_ID().x][tasks[0].get_ID().y].task.goalState
	main.get_node("Multiplayer_Tasks").send_update_task([tasks[0].get_ID(),\
	task_locations[tasks[0].get_ID().x][tasks[0].get_ID().y].task.goalState])
	
