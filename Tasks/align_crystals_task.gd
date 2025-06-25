extends Node2D

var main #instantiated in ready
var state = 0 #game state, num of aligned crystals
var goalState = null #the target state, initialized when task is added to task board

var NAMES = ["Trilithium", "Iridium", "Rutherfordium", "Big Rock", "Dicesium", "Difluorite", "Bismuth"]
static var available_names = ["Trilithium", "Iridium", "Rutherfordium", "Big Rock", "Dicesium", "Difluorite", "Bismuth"]

var task_name = ""


func setUp():
	if len(available_names) == 0:
		return false
	randomize()
	var ind = int(randf_range(0, len(available_names)))
	task_name = available_names[ind]
	available_names.pop_at(ind)
	
	return true

func _ready():
	main = get_tree().root.get_node("Main")
	$Crystal/CollisionPolygon2D.disabled = true
	$Crystal/Alignment_Checker/CollisionShape2D.disabled = true
	$Crystal2/CollisionPolygon2D.disabled = true
	$Crystal2/Alignment_Checker/CollisionShape2D.disabled = true
	$Crystal3/CollisionPolygon2D.disabled = true
	$Crystal3/Alignment_Checker/CollisionShape2D.disabled = true
	$Crystal4/CollisionPolygon2D.disabled = true
	$Crystal4/Alignment_Checker/CollisionShape2D.disabled = true
	
	$RayCast2D.enabled = false
	$RayCast2D2.enabled = false
	$RayCast2D3.enabled = false
	$RayCast2D4.enabled = false
	
	$Crystal.set_process(false)
	$Crystal2.set_process(false)
	$Crystal3.set_process(false)
	$Crystal4.set_process(false)
	

#called by assigned task_location object
func open():
	$Crystal/CollisionPolygon2D.disabled = false
	$Crystal/Alignment_Checker/CollisionShape2D.disabled = false
	$Crystal2/CollisionPolygon2D.disabled = false
	$Crystal2/Alignment_Checker/CollisionShape2D.disabled = false
	$Crystal3/CollisionPolygon2D.disabled = false
	$Crystal3/Alignment_Checker/CollisionShape2D.disabled = false
	$Crystal4/CollisionPolygon2D.disabled = false
	$Crystal4/Alignment_Checker/CollisionShape2D.disabled = false
	
	$RayCast2D.enabled = true
	$RayCast2D2.enabled = true
	$RayCast2D3.enabled = true
	$RayCast2D4.enabled = true
	
	$Crystal.set_process(true)
	$Crystal2.set_process(true)
	$Crystal3.set_process(true)
	$Crystal4.set_process(true)
	
	if goalState != null:
		check_alignment()
	
func close():
	$Crystal/CollisionPolygon2D.disabled = true
	$Crystal/Alignment_Checker/CollisionShape2D.disabled = true
	$Crystal2/CollisionPolygon2D.disabled = true
	$Crystal2/Alignment_Checker/CollisionShape2D.disabled = true
	$Crystal3/CollisionPolygon2D.disabled = true
	$Crystal3/Alignment_Checker/CollisionShape2D.disabled = true
	$Crystal4/CollisionPolygon2D.disabled = true
	$Crystal4/Alignment_Checker/CollisionShape2D.disabled = true
	
	$RayCast2D.enabled = false
	$RayCast2D2.enabled = false
	$RayCast2D3.enabled = false
	$RayCast2D4.enabled = false
	
	$Crystal.set_process(false)
	$Crystal2.set_process(false)
	$Crystal3.set_process(false)
	$Crystal4.set_process(false)

#is being assigned a goal by task_board so set a goalState prob to what state it is not
func make_goal():
	randomize()
	goalState = 4
	#randomize crystal spots
	$Crystal.global_position.x = int(randf_range(500, 1420))
	$Crystal2.global_position.x = int(randf_range(500, 1420))
	$Crystal3.global_position.x = int(randf_range(500, 1420))
	$Crystal4.global_position.x = int(randf_range(500, 1420))
	
	main.get_node("Multiplayer_Tasks").send_update_task([get_parent().get_parent().get_ID(),\
			"Align Crystals", state,$Crystal.global_position, $Crystal2.global_position,\
			$Crystal3.global_position, $Crystal4.global_position])
	
	return "Align Crystals"

#only run by main i think
func check_alignment():
	if $RayCast2D.is_colliding():
		if $RayCast2D2.is_colliding():
			if $RayCast2D3.is_colliding():
				if $RayCast2D4.is_colliding():
					state = 4
				else:
					state = 3
			else:
				state = 2
		else:
			state = 1
	else:
		state = 0




#updates the task in server called by update_task in multiplayer_tasks
#also called by clients from server then sending info out to clients
func update_task(info):
	if info[1] == "Align Crystals":
		state = info[2]
		$Crystal.global_position = info[3]
		$Crystal2.global_position = info[4]
		$Crystal3.global_position = info[5]
		$Crystal4.global_position = info[6]
		if main.my_ID == 1:
			if goalState == state:
				goalState = null
				main.currMap.task_board.task_completed(get_parent().get_parent().ID)


func _on_control_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed == false:
			$Crystal.dragging = false
			$Crystal2.dragging = false
			$Crystal3.dragging = false
			$Crystal4.dragging = false
			
			check_alignment()
			#update other positions
			main.get_node("Multiplayer_Tasks").send_update_task([get_parent().get_parent().get_ID(),\
			"Align Crystals", state,$Crystal.global_position, $Crystal2.global_position,\
			$Crystal3.global_position, $Crystal4.global_position])


func override():
	if goalState != null:
		$Crystal.global_position.x = 960
		$Crystal2.global_position.x = 960
		$Crystal3.global_position.x = 960
		$Crystal4.global_position.x = 960
		state = 4
		main.get_node("Multiplayer_Tasks").send_update_task([get_parent().get_parent().get_ID(),\
			"Align Crystals", state,$Crystal.global_position, $Crystal2.global_position,\
			$Crystal3.global_position, $Crystal4.global_position])
