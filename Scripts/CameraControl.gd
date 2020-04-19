extends Camera2D

var center_screen = Vector2(1920/2,1080/2)
var normal_zoom = Vector2(1,1)
var main_menu_zoom
var main_menu_position

func _ready():
	main_menu_zoom = zoom
	main_menu_position = position
	
func exit_main_menu():
	$Tween.interpolate_property(self, "zoom", main_menu_zoom, normal_zoom, 2,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT )
	$Tween.interpolate_property(self, "position", main_menu_position, center_screen , 2,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT )
	$Tween.start()

func game_mode():
	self.position = center_screen
	self.zoom = normal_zoom
