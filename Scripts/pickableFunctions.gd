extends Node
 
func speed_up():
	GameManager.player.max_speed += 100
	GameManager.player.powerup_text('speed')
	var timer = Timer.new()
	timer.connect("timeout",self,'speed_up_restore', [timer]) 
	self.add_child(timer)
	timer.start(5)

func speed_up_restore(arg):
	arg.queue_free()
	GameManager.player.max_speed -= 100
