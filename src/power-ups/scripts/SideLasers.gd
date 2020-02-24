extends PowerUpAttach

var counter := 2
var limit := 2

func on_shot():
	if counter >= limit:
		attached_to.shoot_projectile(preload("res://src/projectiles/LaserProjectile.tscn").instance(),
		(Vector2.UP + Vector2.LEFT / 2).normalized() * attached_to.shot_speed / 1.5, 10, "Left")
		attached_to.shoot_projectile(preload("res://src/projectiles/LaserProjectile.tscn").instance(),
		(Vector2.UP + Vector2.RIGHT / 2).normalized() * attached_to.shot_speed / 1.5, 10, "Right")
		counter = 0
	else:
		counter += 1
