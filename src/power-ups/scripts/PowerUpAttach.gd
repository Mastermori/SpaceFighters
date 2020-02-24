extends Node2D

class_name PowerUpAttach

var attached_to : Character

# To be overwritten - called when modifiers to vars should be applied
func apply_modifiers():
	pass

# To be overwritten - called when modifiers to vars should be removed
func remove_modifiers():
	pass

# To be overwritten - called when a shot is fired
func on_shot():
	pass

func attach(character : Character, duration : float):
	attached_to = character
	character.add_power_up(name, self, duration)
