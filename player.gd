extends CharacterBody2D
class_name Player

var my_ID

const SPEED = 840 * 3

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


var data = {}

func set_ID(id):
	my_ID = id


func _ready():
	$HUD/InteractButton.visible = false
	
	if get_tree().root.get_node("Main").my_ID != 1:
		$CollisionShape2D.disabled = true
		
		set_process(false)
	else:
		data["position"] = global_position
	
	if get_tree().root.get_node("Main").my_ID == my_ID:
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
	if area is Task_Location and my_ID == get_tree().root.get_node("Main").my_ID:
		task_locations.append(area)
		$HUD/InteractButton.visible = true

func interactable_area_exited(area):
	if area is Task_Location and my_ID == get_tree().root.get_node("Main").my_ID:
		task_locations.erase(area)
		if len(task_locations) == 0:
			$HUD/InteractButton.visible = false

#only runs on client on own player
func interact_button_pressed():
	pass # Replace with function body.



func update_game_state(dataa):
	global_position = dataa["position"]
