extends KinematicBody2D

export (int) var speed = 200
export (bool) var isDead = false 
export (bool) var enabled = true


var velocity = Vector2()
var action = false
var colider = null


func animation_movement(right,left,down,up):
#	In charge of the animation of the charcter
	if right and not up and not down:
		$walk_animation.flip_h = false
		$walk_animation.play("side")
	elif left and not up and not down:
		$walk_animation.flip_h = true
		$walk_animation.play("side")
	elif down and not right and not left:
		$walk_animation.play("down")
	elif up and not right and not left:
		$walk_animation.play("up")
	elif up and right:
		$walk_animation.flip_h = false
		$walk_animation.play("up side")
	elif up and left:
		$walk_animation.flip_h = true
		$walk_animation.play("up side")
	elif down and right:
		$walk_animation.flip_h = false
		$walk_animation.play("down side")
	elif down and left:
		$walk_animation.flip_h = true
		$walk_animation.play("down side")
	else:
		$walk_animation.play("standing")
		
func get_input():
	#	Input handler
	velocity = Vector2()
	var is_right_presed = Input.is_action_pressed('ui_right')
	var is_left_presed = Input.is_action_pressed('ui_left')
	var is_down_presed = Input.is_action_pressed('ui_down')
	var is_up_presed = Input.is_action_pressed('ui_up')
	#	Adds to velocity
	if is_right_presed:
		velocity.x += 1
	if is_left_presed:
		velocity.x -= 1
	if is_down_presed:
		velocity.y += 1
	if is_up_presed:
		velocity.y -= 1
	velocity = velocity.normalized() * speed
	animation_movement(is_right_presed,is_left_presed,is_down_presed,is_up_presed)

func _physics_process(_delta):
	#	Movement of player
	if not isDead and enabled:
		get_input()
		var collision = move_and_collide(velocity * _delta)
		if collision:
			colider = collision.get_collider()
			if colider.get_parent().name != "Items": #checks if collider is an item.
				colider = null
			velocity = velocity.slide(collision.normal)
		else:
			colider = null
		velocity = move_and_slide(velocity)
		
func _process(_delta):
	if Input.is_action_pressed('ui_action') and colider:
		colider.action()
	if Input.is_action_just_released('ui_action') and colider:
		colider.end_action()

func ready():
	pass

func die():
	isDead = true

func disable():
	enabled = false
	$walk_animation.hide()

func enable():
	enabled = true
	$walk_animation.show()
