# Manager node of entire item list

extends Node2D

# Functions

func _process(_delta):
	check_dead()

func restart():
	# Restart Logic
	
	for item in get_children():
		item.restart()
		
func check_dead():
	# Checks if player has died
	if Input.is_action_pressed("ui_die"):
		GameManager.die()
	if not GameManager.is_dead:
		for item in get_children():
			if item.stat <= 0:
				GameManager.die()
