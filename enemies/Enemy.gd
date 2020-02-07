extends Character

class_name Enemy

export var onscreen_speed := 350.0
export var offscreen_speed := 50

var speed := offscreen_speed

onready var follow : PathFollow2D = get_parent()

func _process(delta):
	follow.offset += speed * delta


func die():
	.die()

func _on_VisibilityNotifier2D_screen_entered():
	speed = onscreen_speed

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
