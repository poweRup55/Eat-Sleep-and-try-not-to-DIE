# Item logic
extends RigidBody2D

# Constants
const STATUS_BAR = preload("res://scenes/Stat.tscn")

# Variables
export var nameOfStat = "GeneralName"
export var max_stat = 100
export var stat = 100
export var start_stat = 100
export var add_to_stat = 0.5 
export var reduce_from_stat = 0.5
export (float) var intervals = 2
export (bool) var is_enabled = false

var defualt_values = [max_stat,stat,start_stat,add_to_stat,reduce_from_stat]
var been_enabled = false

var sprite
var interval_timer
var status_bar_instance = STATUS_BAR.instance()
var old_layer_mask = 0
var old_collision_mask = 0

var item_being_used = false

# Functions

func _process(_delta):
	_check_enable()
	
func _check_enable():
	# Enables/Disable logic
	
	if is_enabled:
		if not been_enabled:
			been_enabled= true
			_enable_action()
	else:
		if been_enabled:
			been_enabled= false
			_disable_action()

func _ready():
	sprite = $Sprite
	$AnimatedSprite.hide()
	old_layer_mask = get_collision_layer()
	old_collision_mask = get_collision_mask()
	set_collision_layer(0)
	set_collision_mask(0)
	sprite.hide()
	
func _enable_action():
	# Enable logic
	
	set_collision_layer(old_layer_mask)
	set_collision_mask(old_collision_mask)
	interval_timer = Timer.new()
	GameManager.add_timers(self, interval_timer, "_reduce_stat")
	interval_timer.start(intervals) #to start
	_initialize_progress_bar()
	_fade_in()

func _disable_action():
	# Disable logic
	set_collision_layer(0)
	set_collision_mask(0)
	sprite.hide()
	$CollisionShape2D.hide()
	interval_timer.stop()
	status_bar_instance.disable_action()
	
func _fade_in():
	# Fade in animation
	
	sprite.modulate.a = 0
	sprite.show()
	$Tween.interpolate_property(sprite, "modulate:a", 0, 1.0, 2)
	$Tween.start()
	
func _initialize_progress_bar():
	# Initiates progress bar
	
	status_bar_instance.get_node("Bar").value = stat
	status_bar_instance.get_node("Text").stat_name = nameOfStat
	GameManager.status_bar.add_child(status_bar_instance)
	status_bar_instance.enable_action()

func action():
	# Action button pressed on item logic
	
	item_being_used = true
	sprite.hide()
	GameManager.player.disable()
	$AnimatedSprite.play("use")
	$AnimatedSprite.show()
	_fill_meter()

func _fill_meter():
	# Filles the stat meter
	
	if stat + add_to_stat <= max_stat:
		stat += add_to_stat
		status_bar_instance.get_node("Bar").value = stat

func end_action():
	# Called when getting out of action
	
	item_being_used = false
	sprite.show()
	GameManager.player.enable()
	$AnimatedSprite.hide()

func _reduce_stat():
	# Reduces stat value
	
	if not item_being_used:
		stat -= reduce_from_stat
		status_bar_instance.get_node("Bar").value = stat
	interval_timer.start(intervals)
	
func enable():
	is_enabled = true

func disable():
	is_enabled = false
	
func restart():
	max_stat = defualt_values[0]
	start_stat = defualt_values[2]
	stat = start_stat
	add_to_stat = defualt_values[3]
	reduce_from_stat = defualt_values[4]
	disable()
