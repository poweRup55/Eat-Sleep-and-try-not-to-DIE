extends Node2D

var items
var player 
var status_bar 

func _ready():
	items = $Items
	player = $Player
	status_bar = $Stats
	GameManager.game_ready()
