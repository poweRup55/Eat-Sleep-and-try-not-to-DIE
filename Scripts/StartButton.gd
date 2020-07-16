extends Node2D

const START_ANIM_NAME = 'StartAnimation'
const END_ANIM_NAME = 'EndAnimation'
const LOOP_ANIM_NAME = 'AnimLoop'

func _ready():
	hide()

func enter_main_menu():
	show()
	$AnimationPlayer.play("StartAnimation")

func start_game():
	GameManager._start_game()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == START_ANIM_NAME:
		$AnimationPlayer.play(LOOP_ANIM_NAME)
	elif anim_name == END_ANIM_NAME:
		hide()


func _on_Button_pressed():
	var button = $Sprite/Button
	button.disabled = true
	$AnimationPlayer.play(END_ANIM_NAME)
