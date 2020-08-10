extends Node2D

var appear_timer
var func_array
var appear = false
var set_location = true

func init(func_array_in,appear_timer_in):
	appear_timer = appear_timer_in
	func_array = func_array_in 
	position = Vector2(500,500)
	hide()

func start_appearing():
	hide()
	var random_time = rand_range(1,2)
	appear_timer.start(random_time)

func _on_Appear_timeout():
	appear = true
	appear_timer.stop()
	appear_in_rand_loc()

	# while len($Area2D.get_overlapping_areas()) != 0 or len($Area2D.get_overlapping_bodies()) != 0:

	return
	
func _physics_process(delta):
	if appear:
		if set_location:
			appear_in_rand_loc()
			set_location = false
			return
		var bodies = $Area2D.get_overlapping_bodies()
		if len(bodies) != 0:
			set_location = true
			return
		$AnimationPlayer.play("spin")
		$Area2D.connect("body_entered", self, "player_enter")
		show()
		appear = false
		set_location = true

func appear_in_rand_loc():
	randomize()
	var rand_x = rand_range(100,1911)
	var rand_y = rand_range(343, 1000)
	self.set_global_position(Vector2(rand_x,rand_y))

func player_enter(body):
	$Area2D.disconnect("body_entered", self, "player_enter")
	$AnimationPlayer.play("PickUpAnim")
	var rand = ceil (rand_range(0,len(func_array) - 1)) 
	var func_name = func_array[rand]
	PickableFunctions.call(func_name)
	
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'PickUpAnim':
		start_appearing()
