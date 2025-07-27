extends Node2D
class_name Waste1
#Shred Trash


var main #instantiated in ready
var state = 0 #game state, enabled or not
var goalState = null #the target state, initialized when task is added to task board

var NAMES = []
static var available_names = []

var task_name = "Shred Waste"

var trashObjectScene = preload("res://Tasks/waste_task_1_trash.tscn")
var trash_objects = []

var WALLSPEED = 100
var finished_wait = -150 #set to 5 seconds when done so trash items can disable hitbox and just fall

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
	
	if main.my_ID == 1:
		$wall_left/CollisionShape2D.disabled = false
		$wall_right/CollisionShape2D.disabled = false
		$floor_left/CollisionShape2D.disabled = false
		$floor_right/CollisionShape2D.disabled = false
		$floor_middle/CollisionShape2D.disabled = false
	
	
	$Mouse_Blocker.visible = true
	
	var id = get_parent().get_parent().get_parent().get_parent().get_ID()
	info["color"] = id.x
	info["index"] = id.y
	info["type"] = "Waste Task 1"
	
	info["mouse_blocker_visible"] = $Mouse_Blocker.visible
	info["state"] = state
	
	info["wall_left_pos"] = $wall_left.position
	info["wall_right_pos"] = $wall_right.position
	
	#trash objects (pos + rotation)
	info["trash_objects_info"] = []
	
	if main.my_ID == 1:
		set_process(true)
	else:
		set_process(false)

func get_location_sprite():
	return "waste1"

func open():
	if goalState != null:
		$Mouse_Blocker.visible = false

func close():
	$Mouse_Blocker.visible = true

func make_goal():
	goalState = 50
	$Mouse_Blocker.visible = false
	
	#(re)instantiate trash objects
	for i in range(len(trash_objects)):
		trash_objects[i].queue_free()
	trash_objects = []
	for i in range(10):
		var t = trashObjectScene.instantiate()
		trash_objects.append(t)
		t.position = Vector2((1305-574)/10.0 * i + 574, 300)
		t.rotation = 23
		if main.my_ID != 1:
			t.get_node("CollisionShape2D").disabled = true
		add_child(t)
	#another 5 total 15
	for i in range(5):
		var t = trashObjectScene.instantiate()
		trash_objects.append(t)
		t.position = Vector2((1305-574)/5.0 * i + 574, 200)
		if main.my_ID != 1:
			t.get_node("CollisionShape2D").disabled = true
		add_child(t)
		
	#set wall positions
	$wall_left.position = Vector2(574, 384)
	$wall_right.position = Vector2(1305, 384)
	
	$floor_middle/CollisionShape2D.disabled = false
	
	update_info()
	
	return "Take out Trash"

func button_pressed():
	state += 1
	if state == goalState:
		$Mouse_Blocker.visible = true
	update_info()
	main.get_node("Multiplayer_Tasks").send_update_task(info)

func update_info():
	info["mouse_blocker_visible"] = $Mouse_Blocker.visible
	info["state"] = state
	
	info["wall_left_pos"] = $wall_left.position
	info["wall_right_pos"] = $wall_right.position
	
	
	#trash objects
	
	var temp = []
	for i in range(len(trash_objects)):
		temp.append([trash_objects[i].position, trash_objects[i].rotation])
	
	
	info["trash_objects_info"] = temp

func update_task(info):
	if info["type"] == "Waste Task 1":
		if main.my_ID == 1:
			if info["state"] > state:
				state = info["state"]
		if main.my_ID != 1:
			$Mouse_Blocker.visible = info["mouse_blocker_visible"]
			if info["state"] > state:
				state = info["state"]
			
			$wall_left.position = info["wall_left_pos"]
			$wall_right.position = info["wall_right_pos"]
			
			#trash objects----------------------------------
			#if not same num of trash objects>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
			if len(trash_objects) < len(info["trash_objects_info"]):
				#need to create more trash objects
				for i in range(len(info["trash_objects_info"]) - len(trash_objects)):
					var t = trashObjectScene.instantiate()
					t.position = Vector2(info["trash_objects_info"][len(trash_objects)][0]) #just to place there, will be reset immediately
					trash_objects.append(t)
					if main.my_ID != 1:
						t.get_node("CollisionShape2D").disabled = true
					add_child(t)
			elif len(trash_objects) > len(info["trash_objects_info"]):
				#delete last ones in list until none left
				for i in range(len(trash_objects) - len(info["trash_objects_info"])):
					trash_objects[len(trash_objects)-1].queue_free()
					trash_objects.remove_at(len(trash_objects)-1)
			#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
			
			#set position/rotation of objects
			for i in range(len(info["trash_objects_info"])):
				trash_objects[i].position = info["trash_objects_info"][i][0] #pos
				trash_objects[i].rotation = info["trash_objects_info"][i][1] #rot
			#---------------------------------------------
		
		if main.my_ID == 1 and goalState == state:
			goalState = null
			$Mouse_Blocker.visible = true
			$floor_middle/CollisionShape2D.disabled = true
			var finished_wait = 5
			
			main.currMap.task_board.task_completed(get_parent().get_parent().get_parent().get_parent().ID)

func _process(delta):
	#check if should delete trash object----------------------------
	var ind = len(trash_objects)-1
	while ind >= 0:
		if trash_objects[ind].position.y > 1000:
			trash_objects[ind].queue_free()
			trash_objects.remove_at(ind)
		ind -= 1
	#------------------------------------------------
	
	
	#left wall
	var vL = Vector2(0,0)
	if $wall_left.position.x < state/50.0 * (310-25) + 574:
		vL.x = WALLSPEED
	else:
		vL.x = 0
	$wall_left.position += vL * delta
	
	#right wall
	var vR = Vector2(0,0)
	if $wall_right.position.x > 1305 - state/50.0 * (310-25):
		vR.x = -1 * WALLSPEED
	else:
		vR.x = 0
	$wall_right.position += vR * delta
	
	
	
	#for end of task
	if finished_wait < 0 && finished_wait > -100:
		for i in range(len(trash_objects)):
				trash_objects[i].get_node("CollisionShape2D").disabled = true
		finished_wait = -150
	elif finished_wait > 0:
		finished_wait -= delta
	
	update_info()
	
	main.get_node("Multiplayer_Tasks").send_process_update_task(info)


func override():
	if goalState:
		state = 50
		update_info()
		main.get_node("Multiplayer_Tasks").send_update_task(info)
