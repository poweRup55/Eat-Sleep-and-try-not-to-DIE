#Game over UI box logic

extends Node2D

func init(text_arr):
	$Text.init(text_arr)
	
func text_ended():
	get_parent().text_ended()