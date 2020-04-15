# DialogBox.gd
extends RichTextLabel

# Variables
var dialog = ["[center]GAME OVER![/center]"]
var page = 0
var typing = false

# Functions
func _ready():
	set_process_input(true)
	set_bbcode(dialog[page])
	set_visible_characters(0)

func _process(delta):
	# If action key is pressed, shows entire text
	
	if typing:
		if Input.is_action_pressed("ui_action"):
			if get_visible_characters() > get_total_character_count():
				if page < dialog.size()-1:
					page += 1
					set_bbcode(dialog[page])
					set_visible_characters(0)
			else:
				set_visible_characters(get_total_character_count())

func write_text():
	# Start writing text
	
	typing = true

func _on_Timer_timeout():
	# on timeout - shows one more character
	set_visible_characters(get_visible_characters()+1)
