extends Enemy

class_name Strafer

export(NodePath) var follow_path
export(PackedScene) var path_follow_scene := preload("res://src/characters/enemies/helper/StraferFollow.tscn")

var follow : PathFollow2D

func _ready():
	pass

func enter_screen(use_remote_transform := false):
	if not follow:
		follow = path_follow_scene.instance()
		get_node(follow_path).add_child(follow)
		if use_remote_transform:
			var remote_transform := RemoteTransform2D.new()
			remote_transform.remote_path = get_path()
			follow.add_child(remote_transform)
		else:
			position = Vector2.ZERO
			get_parent().remove_child(self)
			follow.add_child(self)
			set_owner(follow)

func queue_free():
	if follow:
		follow.queue_free()
	.queue_free()

func move(delta):
	follow.offset += onscreen_speed * delta

func shoot():
	shoot_at_player(preload("res://src/projectiles/EnemyProjectile.tscn").instance())
