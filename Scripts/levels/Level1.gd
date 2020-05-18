# Level 1 script
extends Node

# Variables
export (int) var level_duration = 10

# Functions
func _init():
	GameManager.level_changer_timer.start(level_duration)
	GameManager.items.get_node("Fridge")
	
