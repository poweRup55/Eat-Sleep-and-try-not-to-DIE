extends RigidBody2D


const STATUS_BAR = preload("res://Scences/Stat.tscn")

export var nameOfStat = "Sleep"
export var max_stat = 100
export var stat = 100
export var add_to_stat = 0.5 
export var reduce_from_stat = 0.5
export (float) var intervals = 2
export (bool) var enable = false
var been_enabled = false


var sprite
var player
var being_used = false
var timer
var status_bar
var main_node
var status_bar_instance = STATUS_BAR.instance()


func _process(delta):
	if enable:
		if not been_enabled:
			been_enabled= true
			enable_action()
	else:
		if been_enabled:
			been_enabled= false
			disable_action()

func _ready():
	main_node = get_parent().get_parent()
	status_bar = main_node.get_node("Stats")
	player = main_node.get_node("Player")
	sprite = $Sprite
	$AnimatedSprite.hide()
	sprite.hide()
	timer = Timer.new()
	timer.connect("timeout",self,"_on_timer_timeout") 
	add_child(timer) #to process
	
func enable_action():
	sprite.show()
	timer.start(intervals) #to start
	status_bar_instance.get_node("Bar").value = stat
	create_bar()

func create_bar():
	status_bar_instance.get_node("Text").stat_name = nameOfStat
	status_bar.add_child(status_bar_instance)

func action():
	being_used = true
	status_bar_instance.get_node("Bar").value = stat
	sprite.hide()
	player.disable()
	$AnimatedSprite.play("use")
	$AnimatedSprite.show()
	fill_meter()

func fill_meter():
	if stat + add_to_stat <= max_stat:
		stat += add_to_stat

func end_action():
	being_used = false
	sprite.show()
	player.enable()
	$AnimatedSprite.hide()

func _on_timer_timeout():
	if not being_used:
		stat -= reduce_from_stat
		status_bar_instance.get_node("Bar").value = stat
	timer.start(intervals)

func disable_action():
	$AnimatedSprite.hide()
	sprite.hide()
