extends EnemyGroup

class_name StraferGroup

export(NodePath) var follow_path
export(PackedScene) var path_follow_scene := preload("res://enemies/StraferFollow.tscn")

func construct() -> Enemy:
	var strafer : Strafer = .construct()
	strafer.follow_path = get_node(follow_path).get_path()
	strafer.path_follow_scene = path_follow_scene
	return strafer
