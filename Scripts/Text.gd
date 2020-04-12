extends RichTextLabel

export (String) var stat_name = "Food"
var been_enabled = false
var old_layer_mask = 0
var old_collision_mask = 0
onready var static_body = $StaticBody2D


func _ready():
	old_layer_mask = static_body.get_collision_layer()
	old_collision_mask = static_body.get_collision_mask()
	hide()

func enable_action():
#	Enables the node - displayes the text
	if not been_enabled:
		self.add_text("")
		self.bbcode_enabled = true
		var text = "[center]" + stat_name + "[/center]"
		self.append_bbcode(text)
		been_enabled = true	
	show()
	static_body.set_collision_layer(old_layer_mask)
	static_body.set_collision_mask(old_collision_mask)
	
	
func disable_action():
	#	Disables the node - hides the text
	hide()
	static_body.set_collision_layer(0)
	static_body.set_collision_mask(0)
