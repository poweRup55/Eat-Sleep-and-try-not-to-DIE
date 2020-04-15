# Level 2 script
extends Node

# Variables
var text_instance
var text = ["Pretty easy, right?", "dont get used to it!", "go and get some sleep while you can"]
export (int) var level_duration = 10

# Functions

func _init():
	text_instance = GameManager.TEXT_PRELOAD.instance()
	text_instance.init(text)
	add_child(text_instance)
	
func text_ended():
	text_instance.queue_free()
	GameManager.level_changer_timer.start(level_duration)
	GameManager.items.get_children()[1].enable()


