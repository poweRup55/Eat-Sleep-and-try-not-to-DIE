extends Node2D

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = $Fridge.player

func _process(_delta):
	for item in get_children():
		if item.stat <= 0:
			player.die()
