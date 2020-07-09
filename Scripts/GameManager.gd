# God Script

extends Node


# Constants
const path_base_level = "res://Scripts/levels/Level"
const path_level_dir = "res://Scripts/levels"
const TEXT_PRELOAD = preload("res://scenes/GameText.tscn")
const DEAD_PRELOAD = preload("res://scenes/GameOverUi.tscn")
const MAIN_MENU_PRELOAD = preload("res://scenes/MainMenu.tscn")
const PIZZ_PICK_PRELOAD =preload("res://scenes/PickUp.tscn")

# Variables
var is_dead = false
var game_started = false

var cur_level = 0
var cur_level_path
var cur_level_instance
var num_of_levels = _num_of_overall_levels()

var level_changer_timer
var pickable_timer

var game_over_ui
var in_ui = false

export (bool) var debug_mode = false

var main_root
var items
var player
var status_bar
var camera
var main_menu

var pizz_pick_up
var pizz_func_array

var in_main_menu

# Functions

func _process(_delta):
	# Quits when esc pressed 
	# TODO change to main menu
	
	if Input.is_action_pressed("ui_end"):
		get_tree().quit()

	if Input.is_action_just_released("db_skip_level"):
		if not in_main_menu and cur_level < num_of_levels:
			next_level()
	
	if Input.is_action_just_released('ui_skip_level'):
		for item in items.get_children():
			if not item.is_enabled:
				item.enable()
				break
func game_ready():
	# Makes game ready
	
	main_root = get_node("/root/GameMode")
	items = main_root.items
	player = main_root.player
	status_bar = main_root.status_bar
	camera = main_root.camera
	
	main_menu = MAIN_MENU_PRELOAD.instance()
	enter_main_menu()
	add_child(main_menu)
	main_menu.z_index = 10

	
	_change_fullscreen()
	for item in items.get_children():
		item.disable()
	level_changer_timer = Timer.new()
	add_timers(self, level_changer_timer, "next_level")
	if debug_mode:
		camera.game_mode()
		GameManager._start_game()
		
		_execute_level()

func _start_game():
	main_menu.queue_free()
	game_started = true
	if not debug_mode:
		camera.exit_main_menu()

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

func add_pickables(func_array):
	pizz_pick_up = PIZZ_PICK_PRELOAD.instance()
	main_root.add_child(pizz_pick_up)
	pickable_timer = Timer.new()
	add_timers(pizz_pick_up, pickable_timer, '_on_Appear_timeout')
	pizz_pick_up.init(func_array, pickable_timer)
	pizz_pick_up.z_index = player.z_index
	pizz_pick_up.start_appearing()


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
	if cur_level_instance != null:
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
	exit_main_menu()
	cur_level_path = load (_return_level_path())
	if cur_level_path:
		cur_level_instance = cur_level_path.new()
		add_child(cur_level_instance)

func next_level():
	# Loads next level
	if cur_level_instance.in_text:
		cur_level_instance.text_ended()
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

func enter_main_menu():
	in_main_menu = true

func exit_main_menu():
	in_main_menu = false
