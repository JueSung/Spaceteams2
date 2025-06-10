extends Node2D
#completely ran by client(s) and only vital/relavent info sent to server for game state processing

var player_object 

func _ready():
	$HUD.visible = false

#called by assigned task_location object
func open():
	$HUD.visible = true





func bigButton():
	print("WOOOHOOOO")


func click_outside_task(event):
	if event is InputEventMouseButton and event.pressed:
		$HUD.visible = false
		get_parent().close()
