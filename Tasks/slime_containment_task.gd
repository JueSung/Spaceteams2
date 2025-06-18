extends Node2D

var main #instantiated in ready
var state = 0 #game state, num of aligned crystals
var goalState = null #the target state, initialized when task is added to task board

var NAMES = []
static var available_names = []

var task_name = ""





func setUp():
	pass
	##if len(available_names) == 0:
	##	return false
	##randomize()
	##var ind = int(randf_range(0, len(available_names)))
	##task_name = available_names[ind]
	##available_names.pop_at(ind)

func _ready():
	main = get_tree().root.get_node("Main")
	
	$Valve1/Valve/CollisionShape2D.disabled = true
	$Valve2/Valve/CollisionShape2D.disabled = true
	$Valve3/Valve/CollisionShape2D.disabled = true
	$Valve4/Valve/CollisionShape2D.disabled = true
	$Valve5/Valve/CollisionShape2D.disabled = true
	
	$Valve1/Valve.set_process(false)
	$Valve2/Valve.set_process(false)
	$Valve3/Valve.set_process(false)
	$Valve4/Valve.set_process(false)
	$Valve5/Valve.set_process(false)
	
	$Valve1/Slime_Level/CollisionShape2D.disabled = true
	$Valve2/Slime_Level/CollisionShape2D.disabled = true
	$Valve3/Slime_Level/CollisionShape2D.disabled = true
	$Valve4/Slime_Level/CollisionShape2D.disabled = true
	$Valve5/Slime_Level/CollisionShape2D.disabled = true
	


func open():
	$Valve1/Valve/CollisionShape2D.disabled = false
	$Valve2/Valve/CollisionShape2D.disabled = false
	$Valve3/Valve/CollisionShape2D.disabled = false
	$Valve4/Valve/CollisionShape2D.disabled = false
	$Valve5/Valve/CollisionShape2D.disabled = false
	
	$Valve1/Valve.set_process(true)
	$Valve2/Valve.set_process(true)
	$Valve3/Valve.set_process(true)
	$Valve4/Valve.set_process(true)
	$Valve5/Valve.set_process(true)
	
	$Valve1/Slime_Level/CollisionShape2D.disabled = false
	$Valve2/Slime_Level/CollisionShape2D.disabled = false
	$Valve3/Slime_Level/CollisionShape2D.disabled = false
	$Valve4/Slime_Level/CollisionShape2D.disabled = false
	$Valve5/Slime_Level/CollisionShape2D.disabled = false

func close():
	$Valve1/Valve/CollisionShape2D.disabled = true
	$Valve2/Valve/CollisionShape2D.disabled = true
	$Valve3/Valve/CollisionShape2D.disabled = true
	$Valve4/Valve/CollisionShape2D.disabled = true
	$Valve5/Valve/CollisionShape2D.disabled = true
	
	$Valve1/Valve.set_process(false)
	$Valve2/Valve.set_process(false)
	$Valve3/Valve.set_process(false)
	$Valve4/Valve.set_process(false)
	$Valve5/Valve.set_process(false)
	
	$Valve1/Slime_Level/CollisionShape2D.disabled = true
	$Valve2/Slime_Level/CollisionShape2D.disabled = true
	$Valve3/Slime_Level/CollisionShape2D.disabled = true
	$Valve4/Slime_Level/CollisionShape2D.disabled = true
	$Valve5/Slime_Level/CollisionShape2D.disabled = true

func make_goal():
	return "Slime stuff"

func _on_control_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed == false:
			$Valve1/Valve.dragging = false
			$Valve2/Valve.dragging = false
			$Valve3/Valve.dragging = false
			$Valve4/Valve.dragging = false
			$Valve5/Valve.dragging = false
