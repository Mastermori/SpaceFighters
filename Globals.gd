extends Node

enum Factions {
	PLAYER,
	ALIENS,
	NEUTRAL,
}

var player : KinematicBody2D
var level : Node2D


func set_level(l : Node):
	change_scene(l)
	level = l

func find_level(level_name : String):
	var level_inst = load("res://levels/" + level_name + ".tscn").instance()
	set_level(level_inst)

func change_scene(new_scene : Node):
	var root = get_tree().get_root()
	var current = get_tree().current_scene
	level = null
	root.remove_child(current)
	current.call_deferred("free")
	root.add_child(new_scene)
	# Optional, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(new_scene)

