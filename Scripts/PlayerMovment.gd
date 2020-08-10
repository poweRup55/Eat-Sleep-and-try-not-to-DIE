# Player script
extends KinematicBody2D

# Variables

export (int) var max_speed = 400
export (int) var acceleration = 2000
export (int) var friction = 2000

export (bool) var enabled = true

var velocity = Vector2()
var action = false
var colider = null


onready var animationTree = $AnimationTree
onready var animationState = animationTree.get('parameters/playback')

# Functions
func get_input(delta):
	#	Input handler
	
	var input_vector = Vector2.ZERO

	#	Adds to velocity
	input_vector.x += int(Input.is_action_pressed('ui_right'))
	input_vector.x -= int(Input.is_action_pressed('ui_left'))
	input_vector.y += int(Input.is_action_pressed('ui_down'))
	input_vector.y -= int(Input.is_action_pressed('ui_up'))
	
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animationTree.set('parameters/idle/blend_position', input_vector)
		animationTree.set('parameters/Run/blend_position', input_vector)
		animationState.travel('Run')
		velocity = velocity.move_toward(input_vector * max_speed, acceleration*delta)
	else:
		animationState.travel('idle')
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

func powerup_text(power_text):
	
	$TextAbove.set_bbcode("[center]"+power_text+"[/center]")
	$TextAbove/AnimationPlayer.play("powerUpAnim")

func _physics_process(delta):
	#	Movement of player
	if not GameManager.is_dead and enabled:
		get_input(delta)
		var collision = move_and_collide(velocity * delta)
		if collision:
			colider = collision.get_collider()
			if colider.get_parent().name != "Items": #checks if collider is an item.
				colider = null
			velocity = velocity.slide(collision.normal)
		else:
			colider = null
		velocity = move_and_slide(velocity)
		
func _process(_delta):
	if not GameManager.is_dead:
		if Input.is_action_pressed('ui_action') and colider:
			colider.action()
		if Input.is_action_just_released('ui_action') and colider:
			colider.end_action()

func _ready():
	$AnimationTree.active = true

func die():
	$walk_animation.show()
	animationState.travel('death')

func disable():
	enabled = false
	$walk_animation.hide()

func enable():
	enabled = true
	$walk_animation.show()

func restart():
	# Restart logic 
	self.position = GameManager.player_start_position
	$AnimationTree.active = true
	animationState.travel('Run')
	velocity = Vector2.ZERO
	enable()

func _on_AnimationPlayer_death_finished():
	GameManager.game_over()
		
