extends Node
class_name Main

var my_ID = 1 #for instantiation

var players_IDs = [] #for host, #in order as joined from host perspective
var player_objects = {}
var players_inputs = {} #dictionary of player id : dictionary of inputs
var player_datas = {}

var objects = {} #types: Sawblade, Boom
var objects_datas = {}
var objects_to_be_deleted = []

var states = {} #player_datas + objects_datas

var PlayerScene = preload("res://player.tscn")
var MapScene = preload("res://map.tscn")

#For client instantiation scenes
var Scenes = {
	#"Sawblade" : preload("res://sawblade.tscn"),
	#"Boom" : preload("res://boom.tscn")
}

var inGame = false #if in a game, is true

var currMap = null
var sound_percentage = 100

var task_bar_full = false
#phases includes rounds, each phase increases in difficulty in types of tasks ex:
#phase 1 has normal tasks that are completed at station
#phase 2 has harder tasks that are done b/t areas like download upload
#phase 3 has hardest tasks that require multiple people to be doing something simeoultaneously
#or something like that
var phase = 0 #which phase it is, which determines types of tasks, and maybe speed of tasks idk
var round = 0 #which round of a game it is which determines how many tasks, speed of tasks, etc.



func _ready():
	#$HUD.show()
	$Lobby.player_loaded.rpc_id(1)

#called by Lobby sets self either to 1 or the randomly generated id if not host
func set_ID(id):
	my_ID = id
	$Multiplayer_Processing.set_ID(id)
	$Multiplayer_Tasks.set_ID(id)
	
	#initialize map
	var map = MapScene.instantiate()
	add_child(map)
	currMap = map

#recieved from lobby _register_player when player joins both server and clients
#also already runs for self
func add_player(peer_id: Variant, _player_info: Variant):
	players_IDs.append(peer_id)
	var player_instance = PlayerScene.instantiate()
	player_instance.set_ID(peer_id)
	
	#figure out player position, may be handled by Map in the future
	if my_ID == 1:
		# do some calculation to figure out placements of players
		player_instance.position = Vector2(300 + len(player_objects) * 50,300)
	else:
		#just yeet them up there, their positions will be updated shortly
		player_instance.position = Vector2(-100, 540)

	player_objects[peer_id] = player_instance		
	add_child(player_instance)

#signal recieved from lobby _on_player_disconnected if any peer disconnecs
func player_disconnected(peer_id: Variant):
	players_IDs.remove_at(players_IDs.find(peer_id))
	players_inputs.erase(peer_id)
	delete_player(peer_id)
	##player_objects[peer_id].queue_free()
	##player_objects.erase(peer_id)
	##player_datas.erase(peer_id)
	

#for client when/if server disconnects
func server_disconnected():
	return_to_title_page()
	pass # Replace with function body.

#homepage stuff
func host_game():
	$Lobby.create_game()
	$HUD.host_game()
	
	

func join_game():
	if get_node("HUD").get_node("IP").text == "": #needs to enter ip/port info still
		$HUD.enter_ip_info()
	else:
		$HUD.join_game()
		var ip = $HUD.get_node("IP").text
		var port = $HUD.get_node("Port").text
		$Lobby.join_game(ip, port)
		
		

func start_game():
	$HUD.start_game()
	inGame = true
	
	if my_ID == 1:
		$Multiplayer_Processing.start_the_games()
	
	#roll tasks
	if my_ID == 1:
		currMap.assignTasks(round * 2 + len(players_IDs)) #idk change the num later
	
	#initialize players... now at add_player
	#var count = 0
	#for peer_id in players_IDs:
	#	var player_instance = PlayerScene.instantiate()
	#	player_instance.set_ID(peer_id)
	#	
		#figure out player position, may be handled by Map in the future
	#	if my_ID == 1:
			# do some calculation to figure out placements of players
	#		player_instance.position = Vector2(300 + count * 50,300)
	#	else:
	#		#just yeet them up there, their positions will be updated shortly
	#		player_instance.position = Vector2(-100, 540)

	#	player_objects[peer_id] = player_instance		
	#	add_child(player_instance)
	#	count += 1
	

func return_to_title_page():
	inGame = false
	
	for id in player_objects:
		player_objects[id].queue_free()
	player_objects = {}
	player_datas = {}
	players_inputs = {}
	players_IDs = []
	
	for id in objects:
		objects[id].queue_free()
	objects = {}
	objects_datas = {}
	objects_to_be_deleted = []
	
	if currMap != null:
		currMap.queue_free()
		currMap = null

	
	$Lobby.remove_multiplayer_peer()
	$HUD.return_to_title_page()

func set_player_inputs(id, inputs):
	players_inputs[id] = inputs


func _process(delta):
	if my_ID == 1:
		
		for id in player_objects: #enhanced for loop
			if id in players_inputs:
				player_objects[id].update_inputs(players_inputs[id])
			
			player_datas[id] = player_objects[id].get_data()
		#$Multiplayer_Processing.send_player_info(player_datas)
		
		for key in objects:
			if is_instance_valid(objects[key]):
				objects_datas[key] = objects[key].get_data()
		
		#$Multiplayer_Processing.send_object_states(objects_datas) #handles objects to be added via seeing new objects
		states["player_datas"] = player_datas
		states["objects_datas"] = objects_datas
		$Multiplayer_Processing.send_states(states)
		
		$Multiplayer_Processing.send_delete_objects(objects_to_be_deleted)
		objects_to_be_deleted = []

#only ran on server called by big button pressed to start next round maybe also called by start_game()
func next_round():
	round += 1
	#check if next phase (change later)
	
	#assign_tasks in map already resets the task_locations
	var task_bar_goal = round * 2 + len(players_IDs) #current formula for determining num of tasks before round end
	currMap.assignTasks(task_bar_goal)
	

#when sufficient tasks done read by task_bar, told to main here to make big button available
func task_bar_met():
	task_bar_full = true
	#remove any currently available task_elements
	currMap.task_board.set_between_rounds(true)
	while len(currMap.task_board.tasks) > 0:
		currMap.task_board.remove_task(0)
	currMap.task_board.set_between_rounds(false)
	
	#make big button available
	$Multiplayer_Tasks.set_big_button_availability(true)

#only ran on server, when big button is pressed by someone
func big_button_pressed():
	if task_bar_full: #theoretically should always be true, but if lag and two ppl hit at same time or something
		print("BUTTON PRESSED OHHHHHHH")
		$Multiplayer_Tasks.set_big_button_availability(false)
		task_bar_full = false
		next_round()
		




#generally called by multiplayer_processing to get player objects
func get_player_objects():
	return player_objects


#called either by client from msg from server or part of server game state
func delete_player(id):
	if my_ID == 1:
		$Multiplayer_Processing.send_delete_player(id)
		
	if player_objects.has(id):
		player_objects[id].queue_free()
		player_objects.erase(id)
		player_datas.erase(id)
	
		if my_ID == 1:
			if len(player_objects) <= 1:
				end_game()

#called by player when player dies, only called by server
##func player_died(id):
##	delete_player(id)
	
	#if len(player_objects) <= 1:
	#	end_game()

#game ends when 1 or less players
func end_game():
	#send msg to end game
	if not inGame:
		return
		
	inGame = false
	
	if my_ID == 1:
		$Multiplayer_Processing.send_end_game()
	
	currMap.queue_free()
	currMap = null
	
	for id in player_objects:
		player_objects[id].queue_free()
	player_objects = {}
	player_datas = {}
	players_inputs = {}
	
	for id in objects:
		objects[id].queue_free()
	objects = {}
	objects_datas = {}
	objects_to_be_deleted = []
	
	$HUD.visible = true
	if my_ID == 1:
		$HUD.host_game()
	else:
		$HUD.join_game()



#only for server
func main_add_child(object):
	#the formula for consistent stringified name based on object is everything after the ":" in the object name
	var str = str(object)
	str = str.substr(str.find(":") + 1)
	objects[str] = object
	objects_datas[str] = object.get_data()
	add_child(object)

#only for server
func main_delete_object(object):
	#the formula for consistent stringified name based on object is everything after the ":" in the object name
	var str = str(object)
	str = str.substr(str.find(":") + 1)
	objects_to_be_deleted.append(str)
	objects.erase(str)
	objects_datas.erase(str)
	object.queue_free()

#only for clients
func client_delete_objects(objects_to_be_deletedd):
	for i in range(len(objects_to_be_deletedd)):
		var key = objects_to_be_deletedd[i]
		if objects.has(key) and is_instance_valid(objects[key]):
			objects[key].queue_free()
			objects.erase(key)
			objects_datas.erase(key)
		

func update_player_datas(player_datass):
	player_datas = player_datass	
	for id in player_datas:
		if player_objects.has(id) and is_instance_valid(player_objects[id]):
			player_objects[id].update_game_state(player_datass[id])
	
func update_object_states(objects_datass):
	for key in objects_datass:
		#handle new objects, creation
		if not objects.has(key):
			var type = objects_datass[key]["type"]
			match type:
				##"Sawblade":
				##	var obj = Scenes[type].instantiate()
				##	objects[key] = obj
				##	add_child(obj)
				##"Boom":
				##	var obj = Scenes[type].instantiate()
				##	objects[key] = obj
				##	add_child(obj)
				_: #else
					pass
		else:
			if is_instance_valid(objects[key]):
				objects[key].update_game_state(objects_datass[key])
