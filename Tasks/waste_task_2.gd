extends Node2D
class_name Waste2
#Plasma Gasification

#2 steps: drop waste/trash into chamber, activate plasma torches

var main #instantiated in ready
var state = 0 #game state, enabled or not
var goalState = null #the target state, initialized when task is added to task board

var NAMES = []
static var available_names = []

var task_name = "Plasmicly Gasify Waste"

var NUM_PLASMA_TORCHES = 6

var lever_done = false
var circle_plasma_torches_activated = 0
var activated_torches = [false, false, false, false, false, false] #zero index 

func setUp():
	if len(available_names) == 0:
		return false
	randomize()
	var ind = int(randf_range(0, len(available_names)))
	task_name = available_names[ind]
	available_names.pop_at(ind)

func _ready():
	main = get_tree().root.get_node("Main")
	
	$Lever/CollisionShape2D.disabled = true
	$Lever_Detector/CollisionShape2D.disabled = true
	$Circle_Lever/CollisionShape2D.disabled = true
	
	$Lever.set_process(false)
	$Circle_Lever.set_process(false)

func open():
	if not lever_done:
		$Lever/CollisionShape2D.disabled = false
		$Lever_Detector/CollisionShape2D.disabled = false
	$Circle_Lever/CollisionShape2D.disabled = false
	
	
	$Lever.set_process(true)
	$Circle_Lever.set_process(true)

func close():
	$Lever/CollisionShape2D.disabled = true
	$Lever_Detector/CollisionShape2D.disabled = true
	$Circle_Lever/CollisionShape2D.disabled = true
	
	$Lever.set_process(false)
	$Circle_Lever.set_process(false)

func make_goal():
	goalState = true #not used for actual checking state but needed for not null
	$Lever.global_position.y = 200
	lever_done = false
	circle_plasma_torches_activated = 0
	activated_torches = [false, false, false, false, false, false]
	main.get_node("Multiplayer_Tasks").send_update_task([get_parent().get_parent().get_ID(),\
			"Waste Task 2", \
			$Lever.global_position, lever_done, $Circle_Lever.rotation, circle_plasma_torches_activated])
	
	return "Plasma Gasification"


func lever_area_entered(area: Area2D) -> void:
	if area == $Lever_Detector:
		lever_done = true
		$Lever.dragging = false
		$Lever_Detector.set_process(false)
		
func circle_lever_area_entered(area):
	if area == $Plasma_Torch:
		if activated_torches[0] == false:
			activated_torches[0] = true
			circle_plasma_torches_activated += 1
	elif area == $Plasma_Torch2:
		if activated_torches[1] == false:
			activated_torches[1] = true
			circle_plasma_torches_activated += 1
	elif area == $Plasma_Torch3:
		if activated_torches[2] == false:
			activated_torches[2] = true
			circle_plasma_torches_activated += 1
	elif area == $Plasma_Torch4:
		if activated_torches[3] == false:
			activated_torches[3] = true
			circle_plasma_torches_activated += 1
	elif area == $Plasma_Torch5:
		if activated_torches[4] == false:
			activated_torches[4] = true
			circle_plasma_torches_activated += 1
	elif area == $Plasma_Torch6:
		if activated_torches[5] == false:
			activated_torches[5] = true
			circle_plasma_torches_activated += 1
	
			

func update_task(info):
	if info[1] == "Waste Task 2":
		$Lever.global_position = info[2]
		lever_done = info[3]
		$Circle_Lever.rotation = info[4]
		circle_plasma_torches_activated = info[5]
		
		if main.my_ID == 1:
			if goalState != null and lever_done and circle_plasma_torches_activated == NUM_PLASMA_TORCHES:
				goalState = null
				main.currMap.task_board.task_completed(get_parent().get_parent().ID)

func _on_control_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed == false:
			$Lever.dragging = false
			$Circle_Lever.dragging = false
			
			main.get_node("Multiplayer_Tasks").send_update_task([get_parent().get_parent().get_ID(),\
				"Waste Task 2", \
				$Lever.global_position, lever_done, $Circle_Lever.rotation, circle_plasma_torches_activated])

func override():
	if goalState != null:
		$Lever.global_position.y = 550
		lever_done = true
		circle_plasma_torches_activated = 6
		main.get_node("Multiplayer_Tasks").send_update_task([get_parent().get_parent().get_ID(),\
			"Waste Task 2", \
			$Lever.global_position, lever_done, $Circle_Lever.rotation, circle_plasma_torches_activated])
