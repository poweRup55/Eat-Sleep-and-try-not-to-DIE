extends RichTextLabel

# Variables
var dialog = ["ya afasim", "mamsh aval"]
var page = 0
var typing = false
# Functions
func _ready():
	set_process_input(true)
	set_bbcode(dialog[page])
	set_visible_characters(0)
	
func write_text():
	get_parent().text_timer.start(0.1)
	typing = true

func _process(delta):
	if typing:
		if Input.is_action_pressed("ui_accept"):
			if get_visible_characters() > get_total_character_count():
				if page < dialog.size()-1:
					page += 1
					set_bbcode(dialog[page])
					set_visible_characters(0)
				else:
					get_parent().text_ended()
			else:
				set_visible_characters(get_total_character_count())

func _on_Timer_timeout():
	set_visible_characters(get_visible_characters()+1)
