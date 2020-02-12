extends Enemy

export(NodePath) var follow_path
export(PackedScene) var path_follow_scene := preload("res://enemies/StraferFollow.tscn")

var follow : PathFollow2D

func _ready():
	pass

func _physics_process(delta):
	if global_position.x > ProjectSettings.get("display/window/size/width"):
		left_screen()

func exit_screen():
	print("left")

func enter_screen():
	visibility.disconnect("screen_entered", self, "_on_VisibilityNotifier2D_screen_entered")
	follow = path_follow_scene.instance()
	get_node(follow_path).add_child(follow)
	get_parent().remove_child(self)
	follow.add_child(self)
	set_owner(follow)
	visibility.connect("screen_entered", self, "_on_VisibilityNotifier2D_screen_entered")

func move(delta):
	follow.offset += onscreen_speed * delta

func shoot():
	shoot_at_player()
