# Level 2 script
extends Node
var in_text = true
# Variables
var text_instance
var text = ["All this drinking got you...","hmmm... needing a rest?",'Well, heres a rest room for ya']
export (int) var level_duration = 10

# Functions

func _init():
	text_instance = GameManager.TEXT_PRELOAD.instance()
	text_instance.init(text)
	add_child(text_instance)
	
func text_ended():
	in_text = false
	text_instance.queue_free()
	GameManager.level_changer_timer.start(level_duration)
	GameManager.items.get_children()[2].enable()


