extends Control
class_name TaskBoard

var main #instantiated in ready
var TES = preload("res://Tasks/task_board_element.tscn")

var task_locations

var tasks = [] #in order top to bottom

func _ready():
	main = get_tree().root.get_node("Main")
	task_locations = get_parent().get_parent().get_parent().task_locations
	randomize()

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
		add_task()
	
#override button
func do_a_thing() -> void:
	task_locations[tasks[0].get_ID().x][tasks[0].get_ID().y].task.state = \
	task_locations[tasks[0].get_ID().x][tasks[0].get_ID().y].task.goalState
	main.get_node("Multiplayer_Tasks").send_update_task([tasks[0].get_ID(),\
	task_locations[tasks[0].get_ID().x][tasks[0].get_ID().y].task.goalState])
	
