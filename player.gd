extends CharacterBody2D
class_name Player

var main = null
var my_ID

const SPEED = 840# * 3

#user input info ---------
var left = false
var right = false
var up = false
var down = false
var left_click = false
var right_click = false
var mouse_position = Vector2(0,0)
#-------------------------

var task_locations = []
var inTask = false #whether in a task or not

var data = {}

func set_ID(id):
	my_ID = id


func _ready():
	main = get_tree().root.get_node("Main")
	$HUD/InteractButton.visible = false
	
	if main.my_ID != 1:
		$CollisionShape2D.disabled = true
		
		set_process(false)
	else:
		data["position"] = global_position
	
	if main.my_ID == my_ID:
		$HUD/InteractButton.pressed.connect(interact_button_pressed)
	

func _process(delta):
	
	
	var direction = Vector2(0,0)
	#left, right
	if right:
		direction.x += 1
	if left:
		direction.x -= 1
	
	#up, down
	var v_direction = 0
	if up:
		direction.y -= 1
	if down:
		direction.y += 1
	
	if direction:
		direction = direction.normalized()
		velocity = velocity.move_toward(direction * SPEED, SPEED * delta * 30)
	else:
		velocity = velocity.move_toward(Vector2(0,0), 20 * SPEED * delta)
		
	
	
	
	move_and_slide()
	
	
	data["position"] = position


func get_data():
	return data

func update_inputs(inputs):
	left = inputs["left"]
	right = inputs["right"]
	up = inputs["up"]
	down = inputs["down"]
	left_click = inputs["left_click"]
	right_click = inputs["right_click"]
	mouse_position.x = inputs["mouse_position_x"]
	mouse_position.y = inputs["mouse_position_y"]


func interactable_area_entered(area):
	if area is Task_Location and my_ID == main.my_ID:
		task_locations.append(area)
		$HUD/InteractButton.visible = true

func interactable_area_exited(area):
	if area is Task_Location and my_ID == main.my_ID:
		task_locations.erase(area)
		if len(task_locations) == 0:
			$HUD/InteractButton.visible = false

#runs on client on own player or called by multiplayer_processing after rpc call
func interact_button_pressed():
	inTask = true
	if main.my_ID == 1:
		set_process(false) #stop moving if in a task
	if main.my_ID == my_ID:
		if len(task_locations) > 0: #should always be true but for crash avoidance
			task_locations[0].open(self)
			if main.my_ID != 1:
				main.get_node("Multiplayer_Processing").\
				send_to_server_player_function(my_ID, "interact_button_pressed", [])
	

#called by task location in client or fro multiplayer_processing rpc
func close_task():
	inTask = false
	if main.my_ID == my_ID:
		if main.my_ID != 1:
			main.get_node("Multiplayer_Processing").\
			send_to_server_player_function(my_ID, "close_task", [])
	if main.my_ID == 1:
		set_process(true)


func update_game_state(dataa):
	global_position = dataa["position"]
