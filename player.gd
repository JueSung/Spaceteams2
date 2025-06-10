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
	
	
	
	#left, right
	var h_direction = 0
	if right:
		h_direction += 1
	if left:
		h_direction -= 1
	
	if h_direction:
		velocity.x = move_toward(velocity.x, h_direction * SPEED, SPEED * delta * 30)
		
	else:
		velocity.x = move_toward(velocity.x, 0, 20 * SPEED * delta)
	
	#up, down
	var v_direction = 0
	if up:
		v_direction -= 1
	if down:
		v_direction += 1
	
	if v_direction:
		velocity.y = move_toward(velocity.y, v_direction * SPEED, SPEED * delta * 30)
	else:
		velocity.y = move_toward(velocity.y, 0, 20 * SPEED * delta)
		
	
	
	
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

#only runs on client on own player
@rpc ("any_peer", "reliable")
func interact_button_pressed():
	if main.my_ID == 1:
		print("RAn")
		set_process(false)
	if main.my_ID == my_ID:
		if len(task_locations) > 0: #should always be true but for crash avoidance
			task_locations[0].open(self)
			inTask = true
			print(main.my_ID)
			if main.my_ID != 1:
				print("RAN")
				rpc_id(1, "interact_button_pressed")
	

#called by task location in client or rpc from player to tell can move again
@rpc ("any_peer", "reliable")
func close_task():
	if main.my_ID == my_ID:
		inTask = false
		if main.my_ID != 1:
			rpc_id(1, "close_task")
	if main.my_ID == 1:
		print("ran")
		set_process(true)


func update_game_state(dataa):
	global_position = dataa["position"]
