extends Area2D
class_name Task_Location

var ID #Vector2 of Area, pos in area

#object assigned by map at beginning of designated round to be assigned a task
var task = null
#for client ends, the client that opens task, their respective task will have player object assigned here
var player_object = null

#resizes the rectangular shape of the particualr task_location
#dimensions - Vector2(width, height)
func resize(dimensions):
	CollisionShape2D.shape = $CollisionShape2D.shape.duplicate() #separates resource so same scene shapes are independent
	$CollisionShape2D.shape = dimensions

#needs to be ran about at time of instantiation, before allowed to be interacted with by player
func assign_task(taskk):
	task = taskk
	$HUD.add_child(task)
	
	$big_button.visible = false
	$crystal.visible = false
	$enable_button.visible = false
	$slime.visible = false
	$task_board.visible = false
	$waste1.visible = false
	$waste2.visible = false
	
	get_node(task.get_location_sprite()).visible = true

#id is its index in map list
func set_ID(id):
	ID = id

#generally called by its task
func get_ID():
	return ID #Vector2

func _ready():
	$HUD.visible = false
	
#called by multiplayer_tasks
func update_task(info):
	task.update_task(info)
	

#to do the task... called by the client and run only on the client, vital info sent to server
func open(player_objectt):
	player_object = player_objectt
	
	$HUD.visible = true
	task.open()
	#do anything else? idk

#called by button
func close():
	$HUD.visible = false
	task.close()
	player_object.close_task()
	player_object = null

"""func _input(event):
	if event.is_action_pressed("Q"):
		print("RAN")
		if player_object and player_object.inTask:
			print("AH")
			close():"""

func _input(event):
	if event.is_action_pressed("Q"):
		if $HUD.visible:
			override_task()

func override_task() -> void:
	if task != null:
		task.override()
