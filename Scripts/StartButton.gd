extends Node2D

const START_ANIM_NAME = 'startAnimation'
const END_ANIM_NAME = 'startAnimation'
const LOOP_ANIM_NAME = 'AnimLoop'

func _ready():
	$AnimationPlayer.play("StartAnimation")

func start_game():
	GameManager._start_game()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == START_ANIM_NAME:
		$AnimationPlayer.play(LOOP_ANIM_NAME)


func _on_Button_pressed():
	var button = $Sprite/Button
	button.disabled = true
	$AnimationPlayer.play("EndAnimation")
