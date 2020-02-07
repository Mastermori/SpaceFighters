extends Sprite

var vel := Vector2.ZERO

func init(speed : Vector2):
	vel = speed

func _process(delta):
	position += vel * delta

func _on_VisibilityNotifier2D_screen_exited():
	print("Cloud left!")
	queue_free()
