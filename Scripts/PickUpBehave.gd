extends AnimatedSprite


var appear_timer
var func_array

func _ready():
	hide()

func init(func_array_in,appear_timer_in):
	appear_timer = appear_timer_in
	func_array = func_array_in 

func start_appearing():
	hide()
	var random_time = rand_range(1,2)
	appear_timer.start(random_time)

func _on_Appear_timeout():
	appear_timer.stop()
	appear_in_rand_loc()
	var Allitems = GameManager.items.get_children()
	var items = []
	for item in Allitems:
		if item.is_enabled:
			items.append(item)
	for obj in $Area2D.get_overlapping_bodies():
		if obj in items:
			_on_Appear_timeout()
			return
	# while len($Area2D.get_overlapping_areas()) != 0 or len($Area2D.get_overlapping_bodies()) != 0:
	show()
	

func appear_in_rand_loc():
	var rand_x = rand_range(100,1911)
	var rand_y = rand_range(343, 1000)
	self.set_global_position(Vector2(rand_x,rand_y))
	


func _on_Area2D_body_entered(body):
	position = Vector2(0,0)
	var rand = ceil (rand_range(0,len(func_array) - 1)) 
	var func_name = func_array[rand]
	PickableFunctions.call(func_name)
	start_appearing()

