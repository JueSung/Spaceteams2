extends Area2D
class_name Task_Location

#object assigned by map at beginning of designated round to be assigned a task
var task
#for client ends, the client that opens task, their respective task will have player object assigned here
var player_object

#needs to be ran about at time of instantiation, before allowed to be interacted with by player
func assign_task(taskk):
	task = taskk
	task.visible = false


#to do the task... called by the client and run only on the client, vital info sent to server
func open(player_objectt):
	player_object = player_objectt
	
	task.open()
	
	#do anything else? idk

#called by own task
func close():
	player_object.close_task()
