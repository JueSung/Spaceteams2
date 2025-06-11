extends Area2D
class_name Task_Location

var ID

#object assigned by map at beginning of designated round to be assigned a task
var task = null
#for client ends, the client that opens task, their respective task will have player object assigned here
var player_object

#needs to be ran about at time of instantiation, before allowed to be interacted with by player
func assign_task(taskk):
	task = taskk
	$HUD.add_child(task)

#id is its index in map list
func set_ID(id):
	ID = id

func _ready():
	$HUD.visible = false
	
	
#to do the task... called by the client and run only on the client, vital info sent to server
func open(player_objectt):
	player_object = player_objectt
	
	$HUD.visible = true
	task.open()
	#do anything else? idk

#called by own task
func close():
	$HUD.visible = false
	player_object.close_task()

func click_outside_task(event):
	if event is InputEventMouseButton and event.pressed:
		close()
