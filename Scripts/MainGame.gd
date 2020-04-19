# Main game node
extends Node2D

var items
var player 
var status_bar
var camera


func _ready():
	items = $Items
	player = $Player
	status_bar = $Stats
	camera = $Camera2D
	GameManager.game_ready()


func _camera_zoomed_out():
	GameManager._execute_level()
