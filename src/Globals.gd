extends Node

enum Factions {
	PLAYER,
	ALIENS,
	NEUTRAL,
}

var player : KinematicBody2D
var level : Level setget set_level
var level_objects : YSort

func change_level(l : Node):
	set_level(l)
	change_scene(l, false)

func find_level(level_name : String):
	var level_inst = load("res://src/levels/" + level_name + ".tscn").instance()
	change_level(level_inst)

func change_scene(new_scene : Node, clear_level := true):
	var root = get_tree().get_root()
	var current = get_tree().current_scene
	if clear_level:
		level = null
	root.remove_child(current)
	current.call_deferred("free")
	root.add_child(new_scene)
	# Optional, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(new_scene)


func set_level(l : Level):
	print("set level")
	level = l
	level_objects = l.get_node("Objects")
