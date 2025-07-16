extends Node2D
class_name Enabled_Button_Task

var main #instantiated in ready
var state = false #game state, enabled or not
var goalState = null #the target state, initialized when task is added to task board

var NAMES = ["Parapalexus", "Hydrofibril", "Watermelon", "Trilithium Grid", "Hyperconfabulator", "Aerostorage",\
 "Flux Capacitor", "Isoparametric Modulator", "Subspace Conduit", "Tachyon Materializer", "Stove", \
"Static Deflector", "Positronic Confinement Beam", "Harmonic Particle Converter", "Osmotic Containment Field",
"Brew Coffee", "Panic"]
static var available_names = ["Parapalexus", "Hydrofibril", "Watermelon", "Trilithium Grid", "Hyperconfabulator", "Aerostorage",\
 "Flux Capacitor", "Isoparametric Modulator", "Subspace Conduit", "Tachyon Materializer", "Stove", \
"Static Deflector", "Positronic Confinement Beam", "Harmonic Particle Converter", "Osmotic Containment Field", \
"Brew Coffee", "Panic"]

var task_name = ""

var info = {}

#needs to run before _ready()
#rn for name generation, possibly for other stuff later, all rolled tasks need this function
func setUp():
	if len(available_names) == 0:
		return false
	randomize()
	var ind = int(randf_range(0, len(available_names)))
	task_name = available_names[ind]
	available_names.pop_at(ind)
	
	
	return true
	

func _ready():
	
	main = get_tree().root.get_node("Main")
	
	var id = get_parent().get_parent().get_ID()
	info["color"] = id.x
	info["index"] = id.y
	info["type"] = "Enable Button"
	
	info["state"] = state

func get_location_sprite():
	return "enable_button"

#called by assigned task_location object
func open():
	pass

func close():
	pass

#is being assigned a goal by task_board so set a goalState prob to what state it is not
func make_goal():
	goalState = not state
	
	if goalState:
		return "Enable Something Button"
	else:
		return "Disable Something Button"

func button_pressed():
	state = not state
	if state:
		print("Enabled!")
	else:
		print("Disabled!")
	#first elem vector2 of id, second is state
	update_info()
	main.get_node("Multiplayer_Tasks").send_update_task(info)

#self update on current states for info state
func update_info():
	info["state"] = state

#updates the task in server called by update_task in multiplayer_tasks
#also called by clients from server then sending info out to clients
func update_task(info):
	if info["type"] == "Enable Button":
		state = info["state"]
		if main.my_ID == 1:
			if goalState == state:
				goalState = null
				main.currMap.task_board.task_completed(get_parent().get_parent().ID)
	
func override():
	if goalState != null:
		state = goalState
		update_info()
		main.get_node("Multiplayer_Tasks").send_update_task(info)
