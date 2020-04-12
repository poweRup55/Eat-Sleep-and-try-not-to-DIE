extends RigidBody2D


const STATUS_BAR = preload("res://scenes/Stat.tscn")

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
var old_layer_mask = 0
var old_collision_mask = 0

func _process(_delta):
	_check_enable()
	
func _check_enable():
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
	old_layer_mask = get_collision_layer()
	old_collision_mask = get_collision_mask()
	set_collision_layer(0)
	set_collision_mask(0)
	sprite.hide()
	
func enable_action():
	set_collision_layer(old_layer_mask)
	set_collision_mask(old_collision_mask)
	sprite.show()
	timer = Timer.new()
	timer.connect("timeout",self,"_on_timer_timeout") 
	add_child(timer) #to process
	timer.start(intervals) #to start
	status_bar_instance.get_node("Bar").value = stat
	status_bar_instance.get_node("Text").stat_name = nameOfStat
	status_bar.add_child(status_bar_instance)
	status_bar_instance.enable_action()
	
func action():
	being_used = true
	sprite.hide()
	player.disable()
	$AnimatedSprite.play("use")
	$AnimatedSprite.show()
	fill_meter()

func fill_meter():
	if stat + add_to_stat <= max_stat:
		stat += add_to_stat
		status_bar_instance.get_node("Bar").value = stat

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
	set_collision_layer(0)
	set_collision_mask(0)
	sprite.hide()
	$CollisionShape2D.hide()
	timer.stop()
	status_bar_instance.disable_action()

func enable():
	enable = true

func disable():
	enable = false
