extends TextureRect

export var speed_min := 100
export var speed_max := 200

onready var tween := $Tween

func _ready():
	randomize()
	tween.connect("tween_all_completed", self, "move_to_random")
	move_to_random()

func move_to_random():
	yield(get_tree().create_timer(rand_range(3, 10)), "timeout")
	var pos_max = Vector2(0, 0)
	var pos_min = Vector2(Globals.window_width-rect_size.x, Globals.window_height-rect_size.y)
	move_to(Vector2(rand_range(pos_min.x, pos_max.x), rand_range(pos_min.y, pos_max.y)))

func move_to(pos : Vector2):
	var dist = rect_position.distance_to(pos)
	tween.interpolate_property(self, "rect_position", rect_position, pos, rand_range(dist / speed_min, dist / speed_max), Tween.TRANS_SINE)
	tween.start()
