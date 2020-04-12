extends GridContainer


var children = Array()
export (float) var min_shake = 10
export (float) var shake_quant = 20

func shake(obj,rng):
	rng.randomize()
	var x = rng.randf_range(min_shake, shake_quant) * pick_minus(rng)
	var y = rng.randf_range(min_shake, shake_quant) * pick_minus(rng)
	var add_to = Vector2(x,y)
	obj.set_global_position(obj.get_global_position() + add_to)

func pick_minus(rng):
	if rng.randi_range(0,1) == 1:
		return 1
	else:
		return -1

func child_been_added(child):
	children.append(child)

func return_to_og_pos(child, og_pos):
	if og_pos != child.get_global_position():
		child.set_global_position(og_pos)
	
func _process(delta):
	for child in children:
		if child.og_pos == null:
			child.update()
			child.og_pos = child.get_global_position()
