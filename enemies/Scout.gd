extends Enemy

class_name Scout

export var move_interval := .75
export var friction := .97

func _ready():
	pass

func move(delta):
	position += vel * onscreen_speed * delta
	vel *= friction

func enter_screen():
	$MoveTimer.wait_time = move_interval
	$MoveTimer.start()
	enemy_anims.playback_speed = 1 / move_interval
	vel = Vector2.DOWN
	enemy_anims.play("fly")

func shoot():
#	shoot_at_player(preload("res://projectiles/PinkProjectile.tscn").instance())
	shoot_projectile(preload("res://projectiles/LaserProjectile.tscn").instance(), Vector2.DOWN * shot_speed)

func anim_finished(anim_name):
	if anim_name == "fly":
		print("fly finished")
	.anim_finished(anim_name)


func _on_MoveTimer_timeout():
	vel = Vector2.DOWN
	enemy_anims.play("fly")
