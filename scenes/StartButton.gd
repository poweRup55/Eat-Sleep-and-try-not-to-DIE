extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var reverse = false
# Called when the node enters the scene tree for the first time.
func _ready():
	frame = 0;
	play()

func _on_TextureButton_pressed():
	var button = $Button
	button.queue_free()
	reverse = true
	frame = 18;
	speed_scale = 1.5
#	$Tween.interpolate_property(self,"modulate", 
#	Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1.0, 
#	Tween.TRANS_LINEAR, Tween.EASE_IN)
#	$Tween.start()
#

func _process(_delta):
	if not reverse:
		if frame == 18:
			play("", true)
		if frame ==16:
			play("", false)
	else:
		if frame == 18:
			play("", true)
		if frame == 0:
			stop()
			speed_scale = 1
			GameManager._start_game()
