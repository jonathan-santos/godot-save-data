extends Node2D

export (Resource) var save_data
export (PackedScene) var Thing

var game_save_location = "res://saves/game_save.res"
var things := []
var message_timer = 3

func _ready():
	load_save()

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		var mouse_position = get_global_mouse_position()
		create_thing(mouse_position)
		things.append(mouse_position)
	if event is InputEventKey:
		match(event.scancode):
			KEY_ENTER:
				save()	
			KEY_ESCAPE:
				delete_save()

func create_thing(thing_position):
	var new_thing = Thing.instance()
	new_thing.position = thing_position
	add_child(new_thing)

func save():
	var new_save = save_data.new()
	new_save.player_position = $Player.position
	new_save.things = things
	
	var dir = Directory.new()
	if not dir.dir_exists("res://saves/"):
		dir.make_dir_recursive("res://saves/")
	
	ResourceSaver.save(game_save_location, new_save)
	
	message("game saved successfully")
	
func load_save():
	var dir = Directory.new()
	if not dir.file_exists(game_save_location):
		return
	
	var game_save = load(game_save_location)
	if not game_save is save_data:
		return
		
	$Player.position = game_save.player_position
	things = game_save.things
	for thing in things:
		create_thing(thing)
		
	message("Saved game loaded successfully")
		

func delete_save():
	var dir = Directory.new()
	if dir.file_exists(game_save_location):
		dir.remove(game_save_location)
		
		for child in get_children():
			child.hide()
			
		message("Saved game deleted successfully")
		yield(get_tree().create_timer(message_timer), "timeout")
		
		get_tree().reload_current_scene()
		
func message(text):
	$Label.show()
	$Label.text = text
	yield(get_tree().create_timer(message_timer), "timeout")
	$Label.hide()
