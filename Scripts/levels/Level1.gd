# Level 1 script
extends Node
var in_text = false
# Variables
export (int) var level_duration = 10

# Functions
func _init():
	GameManager.level_changer_timer.start(level_duration)
	GameManager.items.get_children()[0].enable()
	
