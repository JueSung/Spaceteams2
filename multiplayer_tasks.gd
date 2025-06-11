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


@rpc("any_peer", "reliable")
func bigButtonPressed():
	if my_ID != 1:
		rpc_id(1, "bigButtonPressed")
	else:
		pass #update game stuff move on to next round or whatever
