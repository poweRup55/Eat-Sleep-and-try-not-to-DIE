# Item logic
extends RigidBody2D

# Constants
const STATUS_BAR = preload("res://scenes/Stat.tscn")

# Variables
export var nameOfStat = "GeneralName"
export var max_stat = 100
export var stat = 100
export var start_stat = 100
export var add_to_stat = 0.2
export var reduce_from_stat = 1
export (float) var intervals = 0.4
export (bool) var is_enabled = false

export var add_reduction_mult_interval = 10
export var maxumin_reduction = 2.5

var default_max_stat 
var default_start_stat
var default_add_to_stat
var default_reduce_from_stat

onready var items_node = get_parent()

var been_enabled = false

var sprite
var animationPlayer
var reduce_stat_timer
var status_bar_instance = STATUS_BAR.instance()
var old_layer_mask = 0
var old_collision_mask = 0
var reduction_multi_timer
var reduction_mult = 1
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
	sprite.hide()
	animationPlayer = $AnimationPlayer
	animationPlayer.play("idle")
	old_layer_mask = get_collision_layer()
	old_collision_mask = get_collision_mask()
	set_collision_layer(0)
	set_collision_mask(0)
	reduce_stat_timer = Timer.new()
	GameManager.add_timers(self, reduce_stat_timer, "_reduce_stat")
	reduction_multi_timer = Timer.new()
	GameManager.add_timers(self, reduction_multi_timer, "_reduce_mult")
	default_max_stat = max_stat
	default_start_stat = start_stat
	default_add_to_stat = add_to_stat
	default_reduce_from_stat = reduce_from_stat
	
func _enable_action():
	# Enable logic
	
	set_collision_layer(old_layer_mask)
	set_collision_mask(old_collision_mask)
	reduction_multi_timer.start(add_reduction_mult_interval)
	reduce_stat_timer.start(intervals) #to start
	_initialize_progress_bar()
	_fade_in()

func _disable_action():
	# Disable logic
	set_collision_layer(0)
	set_collision_mask(0)
	sprite.hide()
	$CollisionShape.hide()
	reduction_multi_timer.stop()
	reduce_stat_timer.stop()
	status_bar_instance.disable_action()
	
func _fade_in():
	# Fade in animation
	
	sprite.modulate.a = 0
	sprite.show()
	items_node.tween.interpolate_property(sprite, "modulate:a", 0, 1.0, 2)
	items_node.tween.start()
	
func _initialize_progress_bar():
	# Initiates progress bar
	
	status_bar_instance.get_node("Bar").value = stat
	status_bar_instance.get_node("Text").stat_name = nameOfStat
	GameManager.status_bar.add_child(status_bar_instance)
	status_bar_instance.enable_action()

func action():
	# Action button pressed on item logic
	
	item_being_used = true
	GameManager.player.disable()
	animationPlayer.play('use')
	_fill_meter()

func _fill_meter():
	# Filles the stat meter
	
	if stat + add_to_stat <= max_stat:
		stat += add_to_stat
		status_bar_instance.get_node("Bar").value = stat

func end_action():
	# Called when getting out of action
	
	item_being_used = false
	GameManager.player.enable()
	animationPlayer.play('idle')

func _reduce_stat():
	# Reduces stat value
	
	if not item_being_used:
		stat -= reduce_from_stat
		status_bar_instance.get_node("Bar").value = stat
	reduce_stat_timer.start(intervals)
	
func enable():
	is_enabled = true

func disable():
	is_enabled = false
	
func restart():
	max_stat = default_max_stat
	start_stat = default_start_stat
	stat = default_start_stat
	add_to_stat = default_add_to_stat
	reduce_from_stat = default_reduce_from_stat
	reduction_mult = 1
	disable()

func _reduce_mult():
	reduction_mult += 0.5
	reduce_from_stat = default_reduce_from_stat * reduction_mult
	if reduce_from_stat < maxumin_reduction:
		reduction_multi_timer.start(add_reduction_mult_interval)
