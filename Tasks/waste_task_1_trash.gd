extends RigidBody2D

func _ready():
	if get_tree().root.get_node("Main").my_ID != 1:
		freeze = true
