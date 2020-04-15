# God Script

extends Node

# Constants
const path_base_level = "res://Scripts/levels/Level"
const path_level_dir = "res://Scripts/levels"
const TEXT_PRELOAD = preload("res://scenes/GameText.tscn")
const DEAD_PRELOAD = preload("res://scenes/GameOverUi.tscn")

# Variables
var is_dead = false

var cur_level = 0
var cur_level_path
var cur_level_instance
var num_of_levels = _num_of_overall_levels()

var level_changer_timer

var game_over_ui
var in_ui = false

export (bool) var debug_mode = true

var main_root
var items
var player
var status_bar
# Functions

func _process(_delta):
	# Quits when esc pressed 
	# TODO change to main menu
	
	if Input.is_action_pressed("ui_end"):
		get_tree().quit()

func game_ready():
	# Makes game ready
	
	main_root = get_node("/root/GameMode")
	items = main_root.items
	player = main_root.player
	status_bar = main_root.status_bar
	
	_change_fullscreen()
	for item in items.get_children():
		item.disable()
	level_changer_timer = Timer.new()
	add_timers(self, level_changer_timer, "next_level")
	_execute_level()

func add_timers(node, timer_var, connect_name = null):
	# Adds timers to a node
	if connect_name:
		timer_var.connect("timeout",node,connect_name) 
	node.add_child(timer_var)

func _change_fullscreen():
	# If debug_mode is on, fullscreen is off. else, it is on.
	
	if debug_mode:
		OS.window_fullscreen = false
	else:
		OS.window_fullscreen = true

func _num_of_overall_levels():
	# Counts how many levels have been made
	
	var num_of_files_temp = 0
	var dir = Directory.new()
	dir.open(path_level_dir)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif file.begins_with("Level"):
			num_of_files_temp += 1
	dir.list_dir_end()
	return num_of_files_temp

func game_over():
	# Game over logic
	
	if not in_ui:
		in_ui = true
		level_changer_timer.stop()
		# Show game over ui 
		game_over_ui = DEAD_PRELOAD.instance()
		add_child(game_over_ui)
		game_over_ui.start_box()

func restart():
	# Restart game logic
	
	is_dead = false
	if cur_level_instance:
		cur_level_instance.queue_free()
	player.restart()
	items.restart()
	cur_level = 0
	in_ui = false
	if game_over_ui:
		game_over_ui.queue_free()
	_execute_level()

func _execute_level():
	# Starts current level
	
	cur_level_path = load (_return_level_path())
	if cur_level_path:
		cur_level_instance = cur_level_path.new()
		add_child(cur_level_instance)

func next_level():
	# Loads next level

	level_changer_timer.stop()
	if cur_level_instance:
		cur_level_instance.queue_free()
	cur_level += 1
	if cur_level < num_of_levels:
		_execute_level()
	
func _return_level_path():
	# Returns the path of the current level script
	
	return path_base_level + str(cur_level) + ".gd"

func die():
	# Player death logic
	is_dead = true
	player.die()