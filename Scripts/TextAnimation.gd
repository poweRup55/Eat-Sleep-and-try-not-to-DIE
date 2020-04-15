extends Sprite

var animationTimer
onready var text = $Text
onready var text_timer = $TextTimer
var end_pos = Vector2(self.position[0], 530)
var start_pos = Vector2(self.position[0], -450)
export (float) var animation_timer_interval = 0.01
export (float) var animation_time = 0.5
var dist_per = ((abs(end_pos[1])+abs(start_pos[1])) / (1 / animation_timer_interval)) / animation_time
var reverse = false

func _ready():
	animationTimer = $AnimationTimer
	self.position = start_pos
	self.z_index = 3
	
func start_box():
	animationTimer.start(animation_timer_interval)
	
func text_ended():
	reverse = true
	animationTimer.start(animation_timer_interval)

func _on_AnimationTimer_timeout():
	if not reverse:
		self.position += Vector2( 0 , dist_per )
		if (self.position >= end_pos):
			animationTimer.stop()
			$TextTimer.start(0.3)
			text.write_text()
		else:
			animationTimer.start(animation_timer_interval)
	else:
		self.position -= Vector2( 0 , dist_per )
		if (self.position <= start_pos):
			animationTimer.stop()
		else:
			animationTimer.start(animation_timer_interval)

func _restart():
	GameManager.restart()
