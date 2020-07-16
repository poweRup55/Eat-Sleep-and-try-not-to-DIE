# Main game node
extends Node2D

var items
var player 
var status_bar
var camera
var main_menu


func _ready():
	items = $Items
	player = $Player
	status_bar = $Stats
	camera = $Camera2D
	main_menu = $MainMenu
	GameManager.game_ready()

func _camera_zoomed_out():
	GameManager._execute_level()
