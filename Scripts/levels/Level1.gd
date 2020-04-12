extends Node

export (int) var level_duration = 60

func _init():
	LevelManager.level_changer_timer.start(level_duration)

func execute():
	LevelManager.items.get_children()[0].enable()
