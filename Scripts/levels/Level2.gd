extends Node

export (int) var level_duration = 2

func _init():
	Level.level_changer_timer.start(level_duration)

func execute():
	LevelManager.items.get_children()[1].enable()
