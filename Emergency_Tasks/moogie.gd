extends CharacterBody2D
class_name Moogie
#Moogie task - moogie walks around and once in a while needs to be petted otherwise massive destruction
var main

var time_til = 1 #time in seconds until change dir,moving/staying put
var info = {}

func _ready():
	#need to be careful - normally task_location.task is a child, but here we are not using assign_task()
	#func to avoid that as the task is self, the parent
	main = get_tree().root.get_node("Main")
	get_node("Task_Location").task = self
	get_node("Task_Location").set_ID(-1) #not a normal task_location
	
	info["color"] = -1
	info["index"] = 0
	info["global_position"] = global_position
	
	randomize()

func _process(delta):
	time_til -= delta
	
	if time_til <= 0:
		#choose action, move (0), or stay put (1)
		var action = int(randf_range(0, 2))
		if action == 0 or velocity == Vector2(0,0): #move, also always move if had just been stay put
			#choose dir
			velocity.x = randf_range(-1, 1)
			velocity.y = randf_range(-1, 1)
			velocity = velocity.normalized()
			#choose speed
			var speed = randf_range(700, 900) #player speed is 840 rn
			velocity *= speed
			#choose how long to move
			time_til = randf_range(3, 8)
		elif action == 1: #stay put
			velocity = Vector2(0,0)
			time_til = randf_range(3, 10) #b/t 3 and 10 seconds to stay put
		else:
			print("Check line 'var action = int(randf_range(0, 2))'")
		
	var v = velocity
	move_and_slide()
	velocity = v
		
	info["global_position"] = global_position
	main.get_node("Multiplayer_Tasks").send_process_update_task(info)
	

func open():
	pass
func close():
	pass
	
func update_task(info):
	global_position = info["global_position"]

func override():
	pass
