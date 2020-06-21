# Level 0 script
extends Node

# Variables
var text_instance
var text = ["Eat, Sleep and try not to DIE!", "GOOD LUCK"]
var in_text = true

# Functions

func _init():
	text_instance = GameManager.TEXT_PRELOAD.instance()
	add_child(text_instance)
	text_instance.init(text)
	
	
func text_ended():
	in_text = false
	text_instance.queue_free()
	GameManager.next_level()
	
