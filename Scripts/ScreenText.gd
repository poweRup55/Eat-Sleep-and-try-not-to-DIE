extends RichTextLabel

# Variables
var text_arr = []
var page = 0
var typing = false
var pause_time = 2
var timer_started = false

# Functions

func init(new_text_arr):
	#Initiates new text on screen
	for i in range(len(new_text_arr)): #Centers the text
		new_text_arr[i] = "[center]"+new_text_arr[i]+"[/center]"
	text_arr = new_text_arr
	set_process_input(true)
	set_bbcode(text_arr[page])
	set_visible_characters(0)

func _process(delta):
	# Countes pause_time seconds before changing text
	if get_visible_characters() == get_total_character_count() and not timer_started:
		timer_started = true
		$TextWaitTimer.start(pause_time)
	
func _on_Timer_timeout():
	if get_visible_characters() < get_total_character_count():
		if timer_started!= false:
			timer_started = false
		set_visible_characters(get_visible_characters()+1)

func _on_TextWaitTimer_timeout():
	$TextWaitTimer.stop()
	if page < text_arr.size()-1:
		page += 1
		set_bbcode(text_arr[page])
		set_visible_characters(0)
	else:
		get_parent().text_ended()
