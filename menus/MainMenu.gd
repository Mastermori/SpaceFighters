extends Control


func _ready():
	print("selecting 1")
	Globals.call_deferred("find_level", "Level1")
