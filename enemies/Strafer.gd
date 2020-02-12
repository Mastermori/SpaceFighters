extends Enemy

class_name Strafer

export(NodePath) var follow_path
export(PackedScene) var path_follow_scene := preload("res://enemies/StraferFollow.tscn")

var follow : PathFollow2D

func _ready():
	pass

func enter_screen():
	if not follow:
		follow = path_follow_scene.instance()
		get_node(follow_path).add_child(follow)
		get_parent().remove_child(self)
		follow.add_child(self)
		set_owner(follow)

func move(delta):
	follow.offset += onscreen_speed * delta

func shoot():
	shoot_at_player()
