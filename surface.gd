extends StaticBody2D
class_name Surface
#meant for walls, etc. handled by Map

#wall types: 0,     1,    2,      3,        4
#           top, bottom, left,   right   diagonal

#unit size of wall should be same as in map
var u = 400
var t = 100 #wall hitbox thickness
var panel_sprites = []

var panel_sprite_scene = preload("res://wall_sprite.tscn")

func setUp(size, pos, rot, wall_type):
	$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate() #separates resource so same scene shapes are independent
	$CollisionShape2D.shape.size = size
	
	match wall_type:
		0:
			var numPanels = int(size.x/u)
			for i in range(numPanels):
				var sprite_instance = panel_sprite_scene.instantiate()
				panel_sprites.append(sprite_instance)
				sprite_instance.get_node("top_down").visible = true
				#									-1    or   1		half a unit
				if numPanels % 2 == 1: #odd num
					sprite_instance.position = Vector2(((i % 2) * 2 - 1) * ((i+1)/2 * u), ((u-t) / 2 - 65) * -1)
				else:
					sprite_instance.position = Vector2(((i % 2) * 2 - 1) * (u/2 + (i/2 * u)), ((u-t) / 2 - 65) * -1)
					
				add_child(sprite_instance)
		1:
			var numPanels = int(size.x/u)
			for i in range(numPanels):
				var sprite_instance = panel_sprite_scene.instantiate()
				panel_sprites.append(sprite_instance)
				sprite_instance.get_node("top_down").visible = true
				#									-1    or   1		half a unit
				if numPanels % 2 == 1: #odd num
					sprite_instance.position = Vector2(((i % 2) * 2 - 1) * ((i+1)/2 * u), ((u-t) / 2 - 65) * 1)
				else:
					sprite_instance.position = Vector2(((i % 2) * 2 - 1) * (u/2 + (i/2 * u)), ((u-t) / 2 - 65) * 1)
					
				add_child(sprite_instance)
		2: #left
			var numPanels = int(size.y/u)
			for i in range(numPanels):
				var sprite_instance = panel_sprite_scene.instantiate()
				panel_sprites.append(sprite_instance)
				sprite_instance.get_node("side").visible = true
				#									-1    or   1		half a unit
				if numPanels % 2 == 1: #odd num
					sprite_instance.position = Vector2(0, ((i % 2) * 2 - 1) * ((i+1)/2 * u))
				else:
					sprite_instance.position = Vector2(0, ((i % 2) * 2 - 1) * (u/2 + (i/2 * u)))
					
				add_child(sprite_instance)
		3:
			var numPanels = int(size.y/u)
			for i in range(numPanels):
				var sprite_instance = panel_sprite_scene.instantiate()
				panel_sprites.append(sprite_instance)
				sprite_instance.get_node("side").visible = true
				#									-1    or   1		half a unit
				if numPanels % 2 == 1: #odd num
					sprite_instance.position = Vector2(0, ((i % 2) * 2 - 1) * ((i+1)/2 * u))
				else:
					sprite_instance.position = Vector2(0, ((i % 2) * 2 - 1) * (u/2 + (i/2 * u)))
					
				add_child(sprite_instance)
		4:
			pass
		_:
			print("not a wall type of the following: 0,1,2,3 :: top, bottom, side, diagonal")

	
	position = pos
	rotation = rot

func _ready():
	if get_tree().root.get_node("Main").my_ID != 1:
		$CollisionShape2D.disabled = true
	
