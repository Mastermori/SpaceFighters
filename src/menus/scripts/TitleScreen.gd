extends Control


func _ready():
	Globals.play_random_music("relaxing", self, -10)

func _on_StartButton_pressed():
	Globals.find_level("Level1")


func _on_ExitButton_pressed():
	get_tree().quit()


func _on_TestButton_pressed():
	pass
