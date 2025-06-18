extends Node2D


var info = {
		"RayCast2D_global_position" : Vector2(0,0), #RayCast2D.global_position
		"Slime_Level_global_position" : Vector2(0,0) #$Slime_Level.global_position
	}

func _ready():
	$Valve/CollisionShape2D.disabled = true
	$Valve.set_process(false)
	$Slime_Level/CollisionShape2D.disabled = true
	$Slime_Level.set_process(false)
	if get_tree().root.get_node("Main").my_ID == 1:
		$Slime_Level.set_process(true)
	
	

func open():
	$Valve/CollisionShape2D.disabled = false
	$Valve.set_process(true)
	$Slime_Level/CollisionShape2D.disabled = false
	#5if get_parent().main.my_ID == 1:
	#	$Slime_Level.set_process(true)

func close():
	$Valve/CollisionShape2D.disabled = true
	$Valve.set_process(false)
	$Slime_Level/CollisionShape2D.disabled = true
	$Slime_Level.set_process(false)

func get_info():
	info["RayCast2D_global_position"] = $RayCast2D.position
	info["Slime_Level_global_position"] = $Slime_Level.global_position
	var to_return = info.duplicate(true) #true makes deep copy so not connected at all
	if info.has("delta_rot"):
		info.erase("delta_rot") #removes the delta_rot element if not applicable for next frame
	return to_return

func update_info(info):
	if get_parent().main.my_ID != 1:
		$RayCast2D.position = info["RayCast2D_global_position"]
	#$Valve.rotation = info[1]
	
		$Slime_Level.global_position = info["Slime_Level_global_position"]
	elif info.has("delta_rot"):
		$Slime_Level.update_target_pos(info["delta_rot"])

"""func process(_delta):
	if $RayCast2D.is_colliding():
		var collider = $RayCast2D.get_collider()
		#slime_level and raycast on mask layer 2, so should never interact with circle thing
		
"""
