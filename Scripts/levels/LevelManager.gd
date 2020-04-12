extends Node


const path_base_level = "res://Scripts/levels/Level"
const TEXT_PRELOAD = preload("res://scenes/DBox.tscn")

var cur_level = 0
var cur_level_path
var cur_level_instance
var level_changer_timer
var gen_use_timer_1
var num_of_levels = num_of_overall_levels()
onready var items = get_node("/root/GameMode/Items")
var text_instance


func _change_level():
	level_changer_timer.stop()
	var level = get_children()[0]
	if level:
		level.queue_free()
	next_level()

func timer_1_out():
	pass

func _ready():
	level_changer_timer = Timer.new() 
	level_changer_timer.connect("timeout",self,"_change_level") 
	add_child(level_changer_timer)
	gen_use_timer_1 = Timer.new() 
	gen_use_timer_1.connect("timeout",self,"timer_1_out") 
	add_child(gen_use_timer_1)
	text_instance = TEXT_PRELOAD.instance()
	add_child(text_instance)
	text_instance.start_box()
	
func text_ended():
	text_instance.queue_free()
	next_level()

func num_of_overall_levels():
	# Counts how many levels have been made
	var num_of_files_temp = 0
	var files = []
	var dir = Directory.new()
	dir.open(path_base_level)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			num_of_files_temp += 1
	dir.list_dir_end()
	return num_of_files_temp - 1

func execute_level():
	cur_level_path = load (return_level_path())
	if cur_level_path:
		cur_level_instance = cur_level_path.new()
		cur_level_instance.execute()

func next_level():
	cur_level += 1
	if cur_level < num_of_levels:
		execute_level()
	
func return_level_path():
	return path_base_level + str(cur_level) + ".gd"

