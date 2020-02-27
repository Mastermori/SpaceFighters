extends Node2D

class_name Level

export(bool) var has_standard_paths := true

func _ready():
	if not Globals.level:
		Globals.level = self
