extends CharacterBody2D
class_name Moogie
#Moogie task - moogie walks around and once in a while needs to be petted otherwise massive destruction

var time_til = 1 #time in seconds until change dir,moving/staying put


func _ready():
	#need to be careful - normally task_location.task is a child, but here we are not using assign_task()
	#func to avoid that as the task is self, the parent
	get_node("Task_Location").task = self
	get_node("Task_Location").set_ID(-1) #not a normal task_location
	
	randomize()

func _process(delta):
	time_til -= delta
	
	if time_til <= 0:
		#choose action, move (0), or stay put (1)
		var action = int(randf_range(0, 2))
		if action == 0: #move
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

func open():
	pass
func close():
	pass
	
func update_task(info):
	pass

func override():
	pass
