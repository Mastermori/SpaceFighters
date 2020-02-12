extends Control


func _ready():
	Globals.call_deferred("find_level", "Level1")
