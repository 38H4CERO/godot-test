extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://nodes/Levels/testMap.tscn")

func _on_quit_button_pressed():
	var popup = $ConfirmationDialog
	popup.show()
	

func _on_confirmation_dialog_confirmed():
	get_tree().quit()
