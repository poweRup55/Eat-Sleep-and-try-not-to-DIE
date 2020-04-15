# Level 0 script
extends Node

# Variables
var text_instance
var text = ["Eat, Sleep and try not to DIE!", "GOOD LUCK"]

# Functions

func _init():
	text_instance = GameManager.TEXT_PRELOAD.instance()
	text_instance.init(text)
	add_child(text_instance)
	
func text_ended():
	text_instance.queue_free()
	GameManager.next_level()
	
