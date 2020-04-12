extends GridContainer

export (int) var start_shaking = 80
export (float) var intervals = 0.1
var og_pos
var timer
var rng = RandomNumberGenerator.new()
var return_to_og = false
var enable = false
var been_enabled = false
onready var stats_grid =  get_parent()
onready var bar = $Bar


func _on_timer_timeout():
	if bar.value <= start_shaking:
		if return_to_og:
			stats_grid.return_to_og_pos(self, og_pos)
		else:
			stats_grid.shake(self, rng)
		return_to_og = !return_to_og
	else:
		stats_grid.return_to_og_pos(self, og_pos)
	timer.start(intervals)

func _process(_delta):
	if enable:
		if not been_enabled:
			been_enabled= true
			enable_action()
	else:
		if been_enabled:
			been_enabled= false
			disable_action()

func _ready():
	timer = Timer.new()
	timer.connect("timeout",self,"_on_timer_timeout") 
	add_child(timer) #to process	

func enable_action():
	stats_grid.get_parent()
	stats_grid.child_been_added(self)
	timer.start(intervals) #to start
	for child in get_children():
		if child != timer:
			child.enable_action()

func disable_action():
	timer.stop()
	stats_grid.remove_child(self)
	for child in get_children():
		if child != timer:
			child.disable_action()
