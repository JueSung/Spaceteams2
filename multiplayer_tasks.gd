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
		get_parent().currMap.task_locations[info[0].x][info[0].y].update_task(info)
	if my_ID == 1:
		get_parent().currMap.task_locations[info[0].x][info[0].y].update_task(info)
		rpc_id(0, "recieve_update_task", id, info)

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

@rpc("any_peer", "reliable")
func bigButtonPressed():
	if my_ID != 1:
		rpc_id(1, "bigButtonPressed")
	else:
		pass #update game stuff move on to next round or whatever
