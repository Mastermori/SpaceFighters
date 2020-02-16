extends EnemyGroup

class_name StraferGroup

export(NodePath) var follow_path
export(PackedScene) var path_follow_scene := preload("res://enemies/StraferFollow.tscn")

func pre_construct():
	if not follow_path:
		var lvl = Globals.level
		if lvl.has_standard_paths:
			if position.x < ProjectSettings.get("display/window/size/width") / 2:
				follow_path = lvl.get_node("StrafePaths/Left").get_path()
			else:
				follow_path = lvl.get_node("StrafePaths/Right").get_path()

func construct(num : int) -> Enemy:
	var strafer : Strafer = .construct(num)
	strafer.follow_path = get_node(follow_path).get_path()
	strafer.path_follow_scene = path_follow_scene
	return strafer
