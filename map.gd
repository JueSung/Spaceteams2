extends Node2D
class_name Map
#gonna say rn theres only one possible map

var SS = preload("res://surface.tscn")

var task_locations = []

func _ready():
	#unit = 200
	var u = 200
	var t = 50 #wall thickness
	
	#Main Area
	#Q1 right
	var instance = SS.instantiate()
	instance.setUp(Vector2(t, 3 * u), Vector2(3 * u + 0.5 * t, -1.5 * u), 0)
	add_child(instance)
	
	#Q1 up
	instance = SS.instantiate()
	instance.setUp(Vector2(3 * u, t), Vector2(1.5 * u,-3 * u - 0.5 * t), 0)
	add_child(instance)
	
	#Q2 up
	instance = SS.instantiate()
	instance.setUp(Vector2(2 * u, t), Vector2(-2 * u, -3 * u - 0.5 * t), 0)
	add_child(instance)
	
	#Q2 left
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 2 * u), Vector2(-3 * u - 0.5 * t, -2 * u), 0)
	add_child(instance)
	
	#Q3 left
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 3 * u), Vector2(-3 * u - 0.5 * t, 1.5 * u), 0)
	add_child(instance)
	
	#Q3 down
	instance = SS.instantiate()
	instance.setUp(Vector2(3 * u, t), Vector2(-1.5 * u, 3 * u + 0.5 * t), 0)
	add_child(instance)
	
	#Q4 down
	instance = SS.instantiate()
	instance.setUp(Vector2(2 * u, t), Vector2(2 * u, 3 * u + 0.5 * t), 0)
	add_child(instance)
	
	#Q4 right
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 2 * u), Vector2(3 * u + 0.5 * t, 2 * u), 0)
	add_child(instance)
	
	#Pink Area
	#1
	instance = SS.instantiate()
	instance.setUp(Vector2(4 * u, t), Vector2(-5 * u, -1 * u - 0.5 * t), 0)
	add_child(instance)
	#2
	instance = SS.instantiate()
	instance.setUp(Vector2(4 * u,  t), Vector2(-5 * u, 0.5 * t), 0)
	add_child(instance)
	#3
	instance = SS.instantiate()
	instance.setUp(Vector2(t, u), Vector2(-7 * u + 0.5 * t, -1.5 * u), 0)
	add_child(instance)
	#4
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 2 * u), Vector2(-7 * u + 0.5 * t, u), 0)
	add_child(instance)
	#5
	instance = SS.instantiate()
	instance.setUp(Vector2(3 * u, t), Vector2(-8.5 * u, -2 * u - 0.5 * t), 0)
	add_child(instance)
	#6
	instance = SS.instantiate()
	instance.setUp(Vector2(t, u), Vector2(-10 * u - 0.5 * t, -1.5 * u), 0)
	add_child(instance)
	#7
	instance = SS.instantiate()
	instance.setUp(Vector2(u, t), Vector2(-10.5 * u, -1 * u -0.5 * t), 0)
	add_child(instance)
	#8
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 2 * u), Vector2(-11 * u + 0.5 * t, -2 * u), 0)
	add_child(instance)
	#9
	instance = SS.instantiate()
	instance.setUp(Vector2(3* u, t), Vector2(-9.5 * u, -3 * u + 0.5 * t), 0)
	add_child(instance)
	#10
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 3 * u), Vector2(-8 * u + 0.5 * t, -4.5 * u), 0)
	add_child(instance)
	#11
	instance = SS.instantiate()
	instance.setUp(Vector2(u, t), Vector2(-8.5 * u, -6 * u - 0.5 * t), 0)
	add_child(instance)
	#12
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 2 * u), Vector2(-10 * u - 0.5 * t, -7 * u), 0)
	add_child(instance)
	#13
	instance = SS.instantiate()
	instance.setUp(Vector2(2 * u, t), Vector2(-11 * u, -6 * u - 0.5 * t), 0)
	add_child(instance)
	#14
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 6 * u), Vector2(-12 * u - 0.5 * t, -3 * u), 0)
	add_child(instance)
	#15
	instance = SS.instantiate()
	instance.setUp(Vector2(2 * u, t), Vector2(-11 * u, 0.5 * t), 0)
	add_child(instance)
	#16
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 2 * u), Vector2(-10 * u - 0.5 * t, 1 * u), 0)
	add_child(instance)
	#17
	instance = SS.instantiate()
	instance.setUp(Vector2(u, t), Vector2(-9.5 * u, 2 * u + 0.5 * t), 0)
	add_child(instance)
	#18
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 3 * u), Vector2(-9 * u -0.5 * t, 3.5 * u), 0)
	add_child(instance)
	#19
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 2 * u), Vector2(-8 * u + 0.5 * t, 3 * u), 0)
	add_child(instance)
	#20
	instance = SS.instantiate()
	instance.setUp(Vector2(u, t), Vector2(-7.5 * u, 2 * u + 0.5 * t), 0)
	add_child(instance)
	#21
	instance = SS.instantiate()
	instance.setUp(Vector2(t, u), Vector2(-9 * u + 0.5 * t, -6.5 * u), 0)
	add_child(instance)
	
	#Blue
	#1
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 3 * u), Vector2(-1 * u - 0.5 * t, -4.5 * u), 0)
	add_child(instance)
	#2
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 3 * u), Vector2(0.5 * t, -4.5 * u), 0)
	add_child(instance)
	#3
	instance = SS.instantiate()
	instance.setUp(Vector2(8 * u, t), Vector2(4 * u, -6 * u + 0.5 * t), 0)
	add_child(instance)
	#4
	instance = SS.instantiate()
	instance.setUp(Vector2(2 * u, t), Vector2(8 * u, -7 * u - 0.5 * t), 0)
	add_child(instance)
	#5
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 3 * u), Vector2(7 * u+ 0.5 * t, -8.5 * u), 0)
	add_child(instance)
	#6
	instance = SS.instantiate()
	instance.setUp(Vector2(3 * u, t), Vector2(5.5 * u, -10 * u - 0.5 * t), 0)
	add_child(instance)
	#7
	instance = SS.instantiate()
	instance.setUp(Vector2(3 * u, t), Vector2(2.5 * u, -7 * u - 0.5 * t), 0)
	add_child(instance)
	#8
	instance = SS.instantiate()
	instance.setUp(Vector2(t, u), Vector2(1 * u + 0.5 * t, -7.5 * u), 0)
	add_child(instance)
	#9
	instance = SS.instantiate()
	instance.setUp(Vector2(2 * sqrt(2) * u, t), Vector2(0.5 * t / sqrt(2), -9 * u - 0.5 * t / sqrt(2)), PI/4.0)
	add_child(instance)
	#10
	instance = SS.instantiate()
	instance.setUp(Vector2(3 * u, t), Vector2(-2.5 * u, -10 * u - 0.5 * t), 0)
	add_child(instance)
	#11
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 2 * u), Vector2(-4 * u - 0.5 * t, -9 * u), 0)
	add_child(instance)
	#12
	instance = SS.instantiate()
	instance.setUp(Vector2(6 * u, t), Vector2(-7 * u, -8 * u - 0.5  * t), 0)
	add_child(instance)
	#13
	instance = SS.instantiate()
	instance.setUp(Vector2(5 * u, t), Vector2(-6.5 * u, -7 * u + 0.5 * t), 0)
	add_child(instance)
	#14
	instance = SS.instantiate()
	instance.setUp(Vector2(t, u), Vector2(-4 * u - 0.5 * t, -6.5 * u), 0)
	add_child(instance)
	#15
	instance = SS.instantiate()
	instance.setUp(Vector2(3 * u, t), Vector2(-2.5 * u, -6 * u + 0.5 * t), 0)
	add_child(instance)
	#16
	instance = SS.instantiate()
	instance.setUp(Vector2(t, 3 * u), Vector2(4 * u - 0.5 * t, -8.5 * u), 0)
	add_child(instance)
	
	
	
	
	#create all map elements
	#floor
	"""var floor = SurfaceScene.instantiate()
	floor.setUp(Vector2(1920, 40), Vector2(1920/2, 1080), 0)
	add_child(floor)
	#walls
	var wall_instance = SurfaceScene.instantiate()
	wall_instance.setUp(Vector2(40,1080), Vector2(0, 540), 0)
	add_child(wall_instance)
	
	wall_instance = SurfaceScene.instantiate()
	wall_instance.setUp(Vector2(40,1080), Vector2(1920, 540), 0)
	add_child(wall_instance)
	
	#ceiling
	var ceiling = SurfaceScene.instantiate()
	ceiling.setUp(Vector2(1920,40), Vector2(1920/2, 0), 0)
	add_child(ceiling)
	
	#ledges
	var ledge = SurfaceScene.instantiate()
	ledge.setUp(Vector2(1920/5.0, 20), Vector2(1920/10.0, 540), 0)
	add_child(ledge)
	
	ledge = SurfaceScene.instantiate()
	ledge.setUp(Vector2(1920/5, 20), Vector2(1920 - 1920/10, 540), 0)
	add_child(ledge)
	
	var task_location = preload("res://task_location.tscn").instantiate()
	task_location.position = Vector2(1920/5.0, 540)
	add_child(task_location)"""
