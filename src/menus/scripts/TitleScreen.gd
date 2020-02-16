extends Control




func _on_StartButton_pressed():
	Globals.find_level("Level1")


func _on_ExitButton_pressed():
	get_tree().quit()
