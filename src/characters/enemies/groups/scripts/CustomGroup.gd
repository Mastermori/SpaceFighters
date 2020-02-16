tool

extends EnemyGroup


func pre_construct():
	if get_child_count() == 1:
		var scene = PackedScene.new()
		scene.pack(get_child(0))
		enemy_scene = scene
		remove_child(get_child(0))
