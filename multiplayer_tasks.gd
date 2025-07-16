extends Node
class_name Multiplayer_Tasks
#for sending signals to server from clients about updated task info stuff

var my_ID = 1 #for instantiation


func set_ID(id):
	my_ID = id

#send task_location assignments to clients from server ran only on server
func send_task_assignments(taskTypes):
	rpc_id(0, "recieve_task_assignments", taskTypes)
@rpc("any_peer", "reliable")
func recieve_task_assignments(taskTypes):
	get_parent().currMap.set_tasks(taskTypes)

#send update task but every frame so sends to main to tell multiplayer processing which is sent back here
#neither functions are rpc, rpc done in multiplayer_processing
func send_process_update_task(info):
	get_parent().get_node("Multiplayer_Processing").append_client_to_server_info("task", [my_ID, info])

func recieve_process_update_task(info):
	for i in range(len(info)):
		if my_ID != info[i][0]:
			if info[i][1]["color"] == -1:#emergency type task
				get_parent().currMap.emergency_tasks[info[i][1]["index"]].update_task(info[i][1])
			else:#normal task
				get_parent().currMap.task_locations[info[i][1]["color"]][info[i][1]["index"]].update_task(info[i][1])
		if my_ID == 1:
			if info[i][1]["color"] == -1:#emergency type task
				get_parent().currMap.emergency_tasks[info[i][1]["index"]].update_task(info[i][1])
			else:#normal task
				get_parent().currMap.task_locations[info[i][1]["color"]][info[i][1]["index"]].update_task(info[i][1])
			get_parent().states["task"].append(info[i])

#send task_informatino to server and other clients via rpc
func send_update_task(info):
	if get_parent().my_ID != 1:
		rpc_id(1, "recieve_update_task", my_ID, info)
	else:
		recieve_update_task(my_ID, info)
#run by server first and then send to same function in clients
@rpc("any_peer", "reliable")
func recieve_update_task(id, info):
	if my_ID != id:
		get_parent().currMap.task_locations[info["color"]][info["index"]].update_task(info)
	if my_ID == 1:
		get_parent().currMap.task_locations[info["color"]][info["index"]].update_task(info)
		rpc_id(0, "recieve_update_task", id, info)





#task board stuff----------------------------------------------------------------------------------
func send_add_board_task(goal, id):
	rpc_id(0, "recieve_add_board_task", goal, id)
@rpc("any_peer", "reliable")
func recieve_add_board_task(goal, id):
	get_parent().currMap.task_board.client_add_task(goal, id)

func send_remove_board_task(index):
	rpc_id(0, "recieve_remove_board_task", index)
@rpc("any_peer", "reliable")
func recieve_remove_board_task(index):
	get_parent().currMap.task_board.remove_task(index)

func send_set_task_bar(taskBar, text):
	rpc_id(0, "recieve_set_task_bar", taskBar, text)
@rpc("any_peer", "reliable")
func recieve_set_task_bar(taskBar, text):
	get_parent().currMap.task_board.set_task_bar(taskBar, text)
#--------------------------------------------------------------------------------------------------

@rpc("any_peer", "reliable")
func set_big_button_availability(available):
	if my_ID == 1:
		rpc_id(0, "set_big_button_availability", available)
	get_parent().currMap.big_button.set_availability(available)

@rpc("any_peer", "reliable")
func bigButtonPressed():
	if my_ID != 1:
		rpc_id(1, "bigButtonPressed")
	else:
		get_parent().big_button_pressed()
