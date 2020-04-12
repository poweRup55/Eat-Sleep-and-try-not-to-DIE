extends Node2D

var timer
var player
var items 
var been_enabled = false
var cur_level = 1


# Main game settings and prep
func _ready():
	OS.window_fullscreen = false #TODO might need changinf
	items = get_node("Items") # Gets items node
#	create_timer()
	player = $Player
	for item in items.get_children():
		item.disable()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("ui_end"):
		get_tree().quit()
	
