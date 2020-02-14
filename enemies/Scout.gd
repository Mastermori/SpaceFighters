extends Enemy

class_name Scout

func _ready():
	pass

func move(delta):
	position.y += onscreen_speed * delta

func shoot():
#	shoot_at_player(preload("res://projectiles/PinkProjectile.tscn").instance())
	shoot_projectile(preload("res://projectiles/LaserProjectile.tscn").instance(), Vector2.DOWN * shot_speed)
