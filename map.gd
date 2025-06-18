extends Node2D
class_name Map
#rn theres only one possible map

var main

#unit = 200
var u = 400
var t = 100#wall thickness
var l = 100 #length of location task area thing

var SS = preload("res://surface.tscn")
var TS = preload("res://task_location.tscn")
var task_scenes = [
	preload("res://Tasks/enable_button_task.tscn"),
	preload("res://Tasks/align_crystals_task.tscn"),
	preload("res://Tasks/waste_task_2.tscn"),
	preload("res://Tasks/waste_1_task_shredder.tscn"),
	preload("res://Tasks/slime_containment_task.tscn")
]

var task_board_location
var task_board

var big_button_location
var big_button


var task_locations = []
var walls = [] #just a list of all the walls

func _ready():
	randomize()
	main = get_tree().root.get_node("Main")
	
	wallSetUp()
	
	taskSetUp()

#assigns tasks to all task_locations
#only ran by server, equivalent is set_tasks
func assignTasks(taskBarGoal):
	#remove any currently assigned tasks
	for i in range(len(task_locations)):
		for j in range(len(task_locations[i])):
			if task_locations[i][j].task != null:
				task_locations[i][j].task.queue_free()
				task_locations[i][j].task = null
	
	#rn just one task so all get that task lol
	var taskTypes = [] #num of index of scene
	for i in range(len(task_locations)):
		taskTypes.append([])
		for j in range(len(task_locations[i])):
			var val = int(randf_range(0, len(task_scenes)))
			var task = task_scenes[val].instantiate()
			task_locations[i][j].assign_task(task)
			taskTypes[i].append(val)
	main.get_node("Multiplayer_Tasks").send_task_assignments(taskTypes)
	
	task_board.set_task_bar_goal(taskBarGoal)
	
	for i in range(4):
		task_board.add_task() #signal to add tasks to task board triggered by add_task() in task_board node

#ran by client called by multiplayer_tasks from info from server
func set_tasks(taskTypes):
	#remove any currently assigned tasks
	for i in range(len(task_locations)):
		for j in range(len(task_locations[i])):
			if task_locations[i][j].task != null:
				task_locations[i][j].task.queue_free()
				task_locations[i][j].task = null
	
	for i in range(len(task_locations)):
		for j in range(len(task_locations[i])):
			var task = task_scenes[taskTypes[i][j]].instantiate()
			task_locations[i][j].assign_task(task)
				



func taskSetUp():
	
	#Button
	big_button_location = TS.instantiate()
	big_button_location.global_position = Vector2(0,0)
	add_child(big_button_location)
	big_button = preload("res://Tasks/button_task.tscn").instantiate()
	big_button_location.assign_task(big_button)
	
	#other task locations stuff
	#Pink Area Labeled by wall
	task_locations.append([])
	#3
	var task_location = TS.instantiate()
	task_location.global_position = Vector2(-7 * u + 0.5 * l, -1.5 * u)
	add_child(task_location)
	task_locations[0].append(task_location)
	#4
	task_location = TS.instantiate()
	task_location.global_position = Vector2(-7 * u + 0.5 * l, 0.5 * u)
	add_child(task_location)
	task_locations[0].append(task_location)
	#5
	task_location = TS.instantiate()
	task_location.global_position = Vector2(-8.5 * u, -2 * u - 0.5 * l)
	add_child(task_location)
	task_locations[0].append(task_location)
	#9
	task_location = TS.instantiate()
	task_location.global_position = Vector2(-9.5 * u, -3 * u + 0.5 * l)
	add_child(task_location)
	task_locations[0].append(task_location)
	#10 low
	task_location = TS.instantiate()
	task_location.global_position = Vector2(-8 * u + 0.5 * l, -3.5 * u)
	add_child(task_location)
	task_locations[0].append(task_location)
	#10 high
	task_location = TS.instantiate()
	task_location.global_position = Vector2(-8 * u + 0.5 * l, -5.5 * u)
	add_child(task_location)
	task_locations[0].append(task_location)
	#13
	task_location = TS.instantiate()
	task_location.global_position = Vector2(-11.5 * u, -6 * u - 0.5 * l)
	add_child(task_location)
	task_locations[0].append(task_location)
	#14
	task_location = TS.instantiate()
	task_location.global_position = Vector2(-12 * u - 0.5 * l, -4.5 * u)
	add_child(task_location)
	task_locations[0].append(task_location)
	#16
	task_location = TS.instantiate()
	task_location.global_position = Vector2(-10 * u - 0.5 * l, 1.5 * u)
	add_child(task_location)
	task_locations[0].append(task_location)
	#20
	task_location = TS.instantiate()
	task_location.global_position = Vector2(-7.5 * u, 2 * u + 0.5 * l)
	add_child(task_location)
	task_locations[0].append(task_location)
	
	#blue
	task_locations.append([])
	#5
	task_location = TS.instantiate()
	task_location.global_position = Vector2(7 * u + 0.5 * l, -8.5 * u)
	add_child(task_location)
	task_locations[1].append(task_location)
	#6
	task_location = TS.instantiate()
	task_location.global_position = Vector2(5.5 * u, -10 * u - 0.5 * l)
	add_child(task_location)
	task_locations[1].append(task_location)
	#16
	task_location = TS.instantiate()
	task_location.global_position = Vector2(4 * u - 0.5 * l, -9.5 * u)
	add_child(task_location)
	task_locations[1].append(task_location)
	#9 low
	task_location = TS.instantiate()
	task_location.global_position = Vector2(0.5 * l / sqrt(2) + 0.5 * u, -8.5 * u - 0.5 * l / sqrt(2))
	task_location.rotation = PI/4
	add_child(task_location)
	task_locations[1].append(task_location)
	#9 high
	task_location = TS.instantiate()
	task_location.global_position = Vector2(0.5 * l / sqrt(2) - 0.5 * u, -9.5 * u - 0.5 * l / sqrt(2))
	task_location.rotation = PI/4
	add_child(task_location)
	task_locations[1].append(task_location)
	#10
	task_location = TS.instantiate()
	task_location.global_position = Vector2(-2.5 * u, -10 * u - 0.5 * l)
	add_child(task_location)
	task_locations[1].append(task_location)
	#11
	task_location = TS.instantiate()
	task_location.global_position = Vector2(-4 * u - 0.5 * l, -9.5 * u)
	add_child(task_location)
	task_locations[1].append(task_location)
	#14
	task_location = TS.instantiate()
	task_location.global_position = Vector2(-4 * u - 0.5 * l, -6.5 * u)
	add_child(task_location)
	task_locations[1].append(task_location)
	#15
	task_location = TS.instantiate()
	task_location.global_position = Vector2(-2.5 * u, -6 * u + 0.5 * l)
	add_child(task_location)
	task_locations[1].append(task_location)
	
	#Yellow
	task_locations.append([])
	#3
	task_location = TS.instantiate()
	task_location.global_position = Vector2(6 * u - 0.5 * l, -1.5 * u)
	add_child(task_location)
	task_locations[2].append(task_location)
	#8
	task_location = TS.instantiate()
	task_location.global_position = Vector2(11 * u - 0.5 * l, -4.5 * u)
	add_child(task_location)
	task_locations[2].append(task_location)
	#9 left
	task_location = TS.instantiate()
	task_location.global_position = Vector2(12.5 * u, -5 * u - 0.5 * l)
	add_child(task_location)
	task_locations[2].append(task_location)
	#9 right
	task_location = TS.instantiate()
	task_location.global_position = Vector2(13.5 * u, -5 * u - 0.5 * l)
	add_child(task_location)
	task_locations[2].append(task_location)
	#14
	task_location = TS.instantiate()
	task_location.global_position = Vector2(16 * u + 0.5 * l, 0.5 * u)
	add_child(task_location)
	task_locations[2].append(task_location)
	#15
	task_location = TS.instantiate()
	task_location.global_position = Vector2(15.5 * u, 2 * u + 0.5 * l)
	add_child(task_location)
	task_locations[2].append(task_location)
	#18 right
	task_location = TS.instantiate()
	task_location.global_position = Vector2(10.5 * u, 2 * u + 0.5 * l)
	add_child(task_location)
	task_locations[2].append(task_location)
	#18 middle
	task_location = TS.instantiate()
	task_location.global_position = Vector2(8.5 * u, 2 * u + 0.5 * l)
	add_child(task_location)
	task_locations[2].append(task_location)
	#18 left
	task_location = TS.instantiate()
	task_location.global_position = Vector2(6.5 * u, 2 * u + 0.5 * l)
	add_child(task_location)
	task_locations[2].append(task_location)
	#20
	task_location = TS.instantiate()
	task_location.global_position = Vector2(8 * u + 0.5 * l, -0.5 * u)
	add_child(task_location)
	task_locations[2].append(task_location)
	#24
	task_location = TS.instantiate()
	task_location.global_position = Vector2(13 * u - 0.5 * l, 0.5 * u)
	add_child(task_location)
	task_locations[2].append(task_location)
	#27
	task_location = TS.instantiate()
	task_location.global_position = Vector2(9.5 * u, 0.5 * l)
	add_child(task_location)
	task_locations[2].append(task_location)
	
	#Green
	task_locations.append([])
	#5
	task_location = TS.instantiate()
	task_location.global_position = Vector2(5.5 * u, 5 * u - 0.5 * l)
	add_child(task_location)
	task_locations[3].append(task_location)
	#7
	task_location = TS.instantiate()
	task_location.global_position = Vector2(7 * u + 0.5 * l,7.5 * u)
	add_child(task_location)
	task_locations[3].append(task_location)
	#8
	task_location = TS.instantiate()
	task_location.global_position = Vector2(5.5 * u, 8 * u + 0.5 * l)
	add_child(task_location)
	task_locations[3].append(task_location)
	#11
	task_location = TS.instantiate()
	task_location.global_position = Vector2(6 * u + 0.5 * l, 11.5 * u)
	add_child(task_location)
	task_locations[3].append(task_location)
	#12
	task_location = TS.instantiate()
	task_location.global_position = Vector2(4.5 * u, 13 * u + 0.5 * l)
	add_child(task_location)
	task_locations[3].append(task_location)
	#16
	task_location = TS.instantiate()
	task_location.global_position = Vector2(-2.5 * u, 9 * u + 0.5 * l)
	add_child(task_location)
	task_locations[3].append(task_location)
	#17
	task_location = TS.instantiate()
	task_location.global_position = Vector2(-3 * u - 0.5 * l, 7.5 * u)
	add_child(task_location)
	task_locations[3].append(task_location)
	#21
	task_location = TS.instantiate()
	task_location.global_position = Vector2(-0.5 * u, 6 * u - 0.5 * l)
	add_child(task_location)
	task_locations[3].append(task_location)
	#28
	task_location = TS.instantiate()
	task_location.global_position = Vector2(0.5 * u, 9 * u + 0.5 * l)
	add_child(task_location)
	task_locations[3].append(task_location)
	#29
	task_location = TS.instantiate()
	task_location.global_position = Vector2(u + 0.5 * l, 7.5 * u)
	add_child(task_location)
	task_locations[3].append(task_location)
	
	
	#assign IDs
	for i in range(len(task_locations)):
		for j in range(len(task_locations[i])):
			task_locations[i][j].set_ID(Vector2(i,j))
	
	#Task_Board
	task_board_location = TS.instantiate()
	task_board_location.global_position = Vector2(1.5 * u, -1.5 * u)
	add_child(task_board_location)
	task_board = preload("res://Tasks/task_board.tscn").instantiate()
	task_board_location.assign_task(task_board)

func wallSetUp():

	##Main Area
	#Q1 right
	var instance = SS.instantiate()
	instance.setUp(Vector2(t, 3 * u), Vector2(3 * u + 0.5 * t, -1.5 * u), 0)
	add_child(instance)
	walls.append(instance)
	
	#Q1 up
	instance = SS.instantiate()
	instance.setUp(Vector2(3 * u, t), Vector2(1.5 * u,-3 * u - 0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	
	#Q2 up
	instance = SS.instantiate()
	instance.setUp(Vector2(2 * u, t), Vector2(-2 * u, -3 * u - 0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	
	#Q2 left
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 2 * u), Vector2(-3 * u - 0.5 * t, -2 * u), 0)
	add_child(instance)
	walls.append(instance)
	
	#Q3 left
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 3 * u), Vector2(-3 * u - 0.5 * t, 1.5 * u), 0)
	add_child(instance)
	walls.append(instance)
	
	#Q3 down
	instance = SS.instantiate()
	instance.setUp(Vector2(3 * u, t), Vector2(-1.5 * u, 3 * u + 0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	
	#Q4 down
	instance = SS.instantiate()
	instance.setUp(Vector2(2 * u, t), Vector2(2 * u, 3 * u + 0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	
	#Q4 right
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 2 * u), Vector2(3 * u + 0.5 * t, 2 * u), 0)
	add_child(instance)
	walls.append(instance)
	
	##Pink Area
	#1
	instance = SS.instantiate()
	instance.setUp(Vector2(4 * u, t), Vector2(-5 * u, -1 * u - 0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	#2
	instance = SS.instantiate()
	instance.setUp(Vector2(4 * u,  t), Vector2(-5 * u, 0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	#3
	instance = SS.instantiate()
	instance.setUp(Vector2(t, u), Vector2(-7 * u + 0.5 * t, -1.5 * u), 0)
	add_child(instance)
	walls.append(instance)
	#4
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 2 * u), Vector2(-7 * u + 0.5 * t, u), 0)
	add_child(instance)
	walls.append(instance)
	#5
	instance = SS.instantiate()
	instance.setUp(Vector2(3 * u, t), Vector2(-8.5 * u, -2 * u - 0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	#6
	instance = SS.instantiate()
	instance.setUp(Vector2(t, u), Vector2(-10 * u - 0.5 * t, -1.5 * u), 0)
	add_child(instance)
	walls.append(instance)
	#7
	instance = SS.instantiate()
	instance.setUp(Vector2(u, t), Vector2(-10.5 * u, -1 * u -0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	#8
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 2 * u), Vector2(-11 * u + 0.5 * t, -2 * u), 0)
	add_child(instance)
	walls.append(instance)
	#9
	instance = SS.instantiate()
	instance.setUp(Vector2(3* u, t), Vector2(-9.5 * u, -3 * u + 0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	#10
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 3 * u), Vector2(-8 * u + 0.5 * t, -4.5 * u), 0)
	add_child(instance)
	walls.append(instance)
	#11
	instance = SS.instantiate()
	instance.setUp(Vector2(u, t), Vector2(-8.5 * u, -6 * u - 0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	#12
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 2 * u), Vector2(-10 * u - 0.5 * t, -7 * u), 0)
	add_child(instance)
	walls.append(instance)
	#13
	instance = SS.instantiate()
	instance.setUp(Vector2(2 * u, t), Vector2(-11 * u, -6 * u - 0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	#14
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 6 * u), Vector2(-12 * u - 0.5 * t, -3 * u), 0)
	add_child(instance)
	walls.append(instance)
	#15
	instance = SS.instantiate()
	instance.setUp(Vector2(2 * u, t), Vector2(-11 * u, 0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	#16
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 2 * u), Vector2(-10 * u - 0.5 * t, 1 * u), 0)
	add_child(instance)
	walls.append(instance)
	#17
	instance = SS.instantiate()
	instance.setUp(Vector2(u, t), Vector2(-9.5 * u, 2 * u + 0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	#18
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 3 * u), Vector2(-9 * u -0.5 * t, 3.5 * u), 0)
	add_child(instance)
	walls.append(instance)
	#19
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 2 * u), Vector2(-8 * u + 0.5 * t, 3 * u), 0)
	add_child(instance)
	walls.append(instance)
	#20
	instance = SS.instantiate()
	instance.setUp(Vector2(u, t), Vector2(-7.5 * u, 2 * u + 0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	#21
	instance = SS.instantiate()
	instance.setUp(Vector2(t, u), Vector2(-9 * u + 0.5 * t, -6.5 * u), 0)
	add_child(instance)
	walls.append(instance)
	
	##Blue
	#1
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 3 * u), Vector2(-1 * u - 0.5 * t, -4.5 * u), 0)
	add_child(instance)
	walls.append(instance)
	#2
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 3 * u), Vector2(0.5 * t, -4.5 * u), 0)
	add_child(instance)
	walls.append(instance)
	#3
	instance = SS.instantiate()
	instance.setUp(Vector2(8 * u, t), Vector2(4 * u, -6 * u + 0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	#4
	instance = SS.instantiate()
	instance.setUp(Vector2(2 * u, t), Vector2(8 * u, -7 * u - 0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	#5
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 3 * u), Vector2(7 * u+ 0.5 * t, -8.5 * u), 0)
	add_child(instance)
	walls.append(instance)
	#6
	instance = SS.instantiate()
	instance.setUp(Vector2(3 * u, t), Vector2(5.5 * u, -10 * u - 0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	#7
	instance = SS.instantiate()
	instance.setUp(Vector2(3 * u, t), Vector2(2.5 * u, -7 * u - 0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	#8
	instance = SS.instantiate()
	instance.setUp(Vector2(t, u), Vector2(1 * u + 0.5 * t, -7.5 * u), 0)
	add_child(instance)
	walls.append(instance)
	#9
	instance = SS.instantiate()
	instance.setUp(Vector2(2 * sqrt(2) * u, t), Vector2(0.5 * t / sqrt(2), -9 * u - 0.5 * t / sqrt(2)), PI/4.0)
	add_child(instance)
	walls.append(instance)
	#10
	instance = SS.instantiate()
	instance.setUp(Vector2(3 * u, t), Vector2(-2.5 * u, -10 * u - 0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	#11
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 2 * u), Vector2(-4 * u - 0.5 * t, -9 * u), 0)
	add_child(instance)
	walls.append(instance)
	#12
	instance = SS.instantiate()
	instance.setUp(Vector2(6 * u, t), Vector2(-7 * u, -8 * u - 0.5  * t), 0)
	add_child(instance)
	walls.append(instance)
	#13
	instance = SS.instantiate()
	instance.setUp(Vector2(5 * u, t), Vector2(-6.5 * u, -7 * u + 0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	#14
	instance = SS.instantiate()
	instance.setUp(Vector2(t, u), Vector2(-4 * u - 0.5 * t, -6.5 * u), 0)
	add_child(instance)
	walls.append(instance)
	#15
	instance = SS.instantiate()
	instance.setUp(Vector2(3 * u, t), Vector2(-2.5 * u, -6 * u + 0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	#16
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 3 * u), Vector2(4 * u - 0.5 * t, -8.5 * u), 0)
	add_child(instance)
	walls.append(instance)
	
	##Yellow
	#1
	instance = SS.instantiate()
	instance.setUp(Vector2(3 * u, t), Vector2(4.5 * u, 1 * u + 0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	#2
	instance = SS.instantiate()
	instance.setUp(Vector2(3 * u, t), Vector2(4.5 * u, -0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	#3
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 3 * u), Vector2(6 * u - 0.5 * t, -1.5 * u), 0)
	add_child(instance)
	walls.append(instance)
	#4
	instance = SS.instantiate()
	instance.setUp(Vector2(2 * u, t), Vector2(7 * u, -3 * u - 0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	#5
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 3 * u), Vector2(8 * u - 0.5 * t, -4.5 * u), 0)
	add_child(instance)
	walls.append(instance)
	#6
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 4 * u), Vector2(9 * u + 0.5 * t, -5 * u), 0)
	add_child(instance)
	walls.append(instance)
	#7
	instance = SS.instantiate()
	instance.setUp(Vector2(2 * u, t), Vector2(10 * u, -3 * u - 0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	#8
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 2 * u), Vector2(11 * u - 0.5 * t, -4 * u), 0)
	add_child(instance)
	walls.append(instance)
	#9
	instance = SS.instantiate()
	instance.setUp(Vector2(3 * u, t), Vector2(12.5 * u, -5 * u - 0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	#10
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 2 * u), Vector2(14 * u + 0.5 * t, -4 * u), 0)
	add_child(instance)
	walls.append(instance)
	#11
	instance = SS.instantiate()
	instance.setUp(Vector2(u, t), Vector2(14.5 * u, -3 * u - 0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	#12
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 2 * u), Vector2(15 * u + 0.5 * t, -2 * u), 0)
	add_child(instance)
	walls.append(instance)
	#13
	instance = SS.instantiate()
	instance.setUp(Vector2(u, t), Vector2(15.5 * u, -1 * u - 0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	#14
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 3 * u), Vector2(16 * u + 0.5 * t, 0.5 * u), 0)
	add_child(instance)
	walls.append(instance)
	#15
	instance = SS.instantiate()
	instance.setUp(Vector2(2 * u, t), Vector2(15 * u, 2 * u + 0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	#16
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 4 * u), Vector2(14 * u + 0.5 * t, 4 * u), 0)
	add_child(instance)
	walls.append(instance)
	#17
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 3 * u), Vector2(13 * u - 0.5 * t, 3.5 * u), 0)
	add_child(instance)
	walls.append(instance)
	#18
	instance = SS.instantiate()
	instance.setUp(Vector2(7 * u, t), Vector2(9.5 * u, 2 * u + 0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	#19
	instance = SS.instantiate()
	instance.setUp(Vector2(t, u), Vector2(6 * u - 0.5 * t, 1.5 * u), 0)
	add_child(instance)
	walls.append(instance)
	#20
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 2 * u), Vector2(8 * u + 0.5 * t, -1 * u), 0)
	add_child(instance)
	walls.append(instance)
	#21
	instance = SS.instantiate()
	instance.setUp(Vector2(6 * u, t), Vector2(11 * u, -2 * u + 0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	#22
	instance = SS.instantiate()
	instance.setUp(Vector2(t, u), Vector2(14 * u - 0.5 * t, -1.5 * u), 0)
	add_child(instance)
	walls.append(instance)
	#23
	instance = SS.instantiate()
	instance.setUp(Vector2(u, t), Vector2(13.5 * u, -1 * u - 0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	#24
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 2 * u), Vector2(13 * u - 0.5 * t, 0), 0)
	add_child(instance)
	walls.append(instance)
	#25
	instance = SS.instantiate()
	instance.setUp(Vector2(2 * u, t), Vector2(12 * u, 1 * u - 0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	#26
	instance = SS.instantiate()
	instance.setUp(Vector2(t, u), Vector2(11 * u + 0.5 * t, 0.5 * u), 0)
	add_child(instance)
	walls.append(instance)
	#27
	instance = SS.instantiate()
	instance.setUp(Vector2(3 * u, t), Vector2(9.5 * u, 0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	
	##Green
	#1
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 3 * u), Vector2(-0.5 * t, 4.5 * u), 0)
	add_child(instance)
	walls.append(instance)
	#2
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 3 * u), Vector2(u + 0.5 * t, 4.5 * u), 0)
	add_child(instance)
	walls.append(instance)
	#3
	instance = SS.instantiate()
	instance.setUp(Vector2(3 * u, t), Vector2(2.5 * u, 6 * u - 0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	#4
	instance = SS.instantiate()
	instance.setUp(Vector2(t, u), Vector2(4 * u - 0.5 * t, 5.5 * u), 0)
	add_child(instance)
	walls.append(instance)
	#5
	instance = SS.instantiate()
	instance.setUp(Vector2(9 * u, t), Vector2(8.5 * u, 5 * u - 0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	#6
	instance = SS.instantiate()
	instance.setUp(Vector2(7 * u, t), Vector2(10.5 * u, 6 * u + 0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	#7
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 2 * u), Vector2(7 * u + 0.5 * t,7 * u), 0)
	add_child(instance)
	walls.append(instance)
	#8
	instance = SS.instantiate()
	instance.setUp(Vector2(2 * u, t), Vector2(6 * u, 8 * u + 0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	#9
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 2 * u), Vector2(5 * u + 0.5 * t, 9 * u), 0)
	add_child(instance)
	walls.append(instance)
	#10
	instance = SS.instantiate()
	instance.setUp(Vector2(u ,t), Vector2(5.5 * u, 10 * u - 0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	#11
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 3 * u), Vector2(6 * u + 0.5 * t, 11.5 * u), 0)
	add_child(instance)
	walls.append(instance)
	#12
	instance = SS.instantiate()
	instance.setUp(Vector2(3 * u, t), Vector2(4.5 * u, 13 * u + 0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	#13
	instance = SS.instantiate()
	instance.setUp(Vector2(t, u), Vector2(3 * u - 0.5 * t, 12.5 * u), 0)
	add_child(instance)
	walls.append(instance)
	#14
	instance = SS.instantiate()
	instance.setUp(Vector2(4 * u, t), Vector2(u, 12 * u + 0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	#15
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 3 * u), Vector2(-1 * u - 0.5 * t, 10.5 * u), 0)
	add_child(instance)
	walls.append(instance)
	#16
	instance = SS.instantiate()
	instance.setUp(Vector2(2 * u, t), Vector2(-2 * u, 9 * u + 0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	#17
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 4 * u), Vector2(-3 * u - 0.5 * t, 7 * u), 0)
	add_child(instance)
	walls.append(instance)
	#18
	instance = SS.instantiate()
	instance.setUp(Vector2(6 * u, t), Vector2(-6 * u, 5 * u + 0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	#19
	instance = SS.instantiate()
	instance.setUp(Vector2(6 * u, t), Vector2(-5 * u, 4 * u - 0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	#20
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 2 * u), Vector2(-2 * u + 0.5 * t, 5 * u), 0)
	add_child(instance)
	walls.append(instance)
	#21
	instance = SS.instantiate()
	instance.setUp(Vector2(2 * u, t), Vector2(-1 * u, 6 * u - 0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	#22
	instance = SS.instantiate()
	instance.setUp(Vector2(3 * u, t), Vector2(2.5 * u, 7 * u + 0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	#23
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 3 * u), Vector2(4 * u - 0.5 * t, 8.5 * u), 0)
	add_child(instance)
	walls.append(instance)
	#24
	instance = SS.instantiate()
	instance.setUp(Vector2(u, t), Vector2(3.5 * u, 10 * u - 0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	#25
	instance = SS.instantiate()
	instance.setUp(Vector2(t, u), Vector2(3 * u - 0.5 * t, 10.5 * u), 0)
	add_child(instance)
	walls.append(instance)
	#26
	instance = SS.instantiate()
	instance.setUp(Vector2(3 * u, t), Vector2(1.5 * u, 11 * u - 0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	#27
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 2 * u), Vector2(0.5 * t, 10 * u), 0)
	add_child(instance)
	walls.append(instance)
	#28
	instance = SS.instantiate()
	instance.setUp(Vector2(u, t), Vector2(0.5 * u, 9 * u + 0.5 * t), 0)
	add_child(instance)
	walls.append(instance)
	#29
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 2 * u), Vector2(u + 0.5 * t, 8 * u), 0)
	add_child(instance)
	walls.append(instance)
	
	print(main.my_ID)
	if main.my_ID != 1:
		for i in range(len(walls)):
			walls[i].get_node("CollisionShape2D").disabled = true
	
	
	#create all map elements
	#floor
	"""var floor = SurfaceScene.instantiate()
	floor.setUp(Vector2(1920, 40), Vector2(1920/2, 1080), 0)
	add_child(floor)
	#walls
	var wall_instance = SurfaceScene.instantiate()
	wall_instance.setUp(Vector2(40,1080), Vector2(0, 540), 0)
	add_child(wall_instance)
	
	wall_instance = SurfaceScene.instantiate()
	wall_instance.setUp(Vector2(40,1080), Vector2(1920, 540), 0)
	add_child(wall_instance)
	
	#ceiling
	var ceiling = SurfaceScene.instantiate()
	ceiling.setUp(Vector2(1920,40), Vector2(1920/2, 0), 0)
	add_child(ceiling)
	
	#ledges
	var ledge = SurfaceScene.instantiate()
	ledge.setUp(Vector2(1920/5.0, 20), Vector2(1920/10.0, 540), 0)
	add_child(ledge)
	
	ledge = SurfaceScene.instantiate()
	ledge.setUp(Vector2(1920/5, 20), Vector2(1920 - 1920/10, 540), 0)
	add_child(ledge)
	
	var task_location = preload("res://task_location.tscn").instantiate()
	task_location.position = Vector2(1920/5.0, 540)
	add_child(task_location)"""
