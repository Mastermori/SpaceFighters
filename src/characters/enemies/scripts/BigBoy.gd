extends Enemy

class_name BigBoy

export var center_position := Vector2(303, 300)
export var move_x_bounds := 100

var rocket_counter := 0
var laser_counter := 0
var biggy_counter := 0

var move_dir = 0

func _ready():
	pass

func move(delta):
	if position.y < center_position.y:
		vel = Vector2.DOWN
	else:
		if move_dir == 0:
			move_dir = -1
		if position.x < center_position.x - move_x_bounds:
			move_dir = 1
		elif position.x > center_position.x + move_x_bounds:
			move_dir = -1
		vel = move_dir * Vector2(1, 0)
	position += vel * onscreen_speed * delta

func enter_screen():
	pass

func shoot():
	biggy_counter += 1
	if biggy_counter > 2:
		bullet_size += Vector2(3, 3)
	shoot_at_player(preload("res://src/projectiles/EnemyProjectile.tscn").instance(), 30, self.shot_speed/2)
	if biggy_counter > 2:
		bullet_size -= Vector2(3, 3)
		biggy_counter = 0
#	shoot_dir(preload("res://src/projectiles/LaserProjectile.tscn").instance(), Vector2.DOWN)

func shoot_rockets():
	print("ROCKETS!!!")

func shoot_lasers():
	print("LASERS!")


func _on_RocketTimer_timeout():
	if on_screen and not dying and should_shoot:
		shoot_rockets()
		emit_signal("shot")

func _on_LaserTimer_timeout():
	if on_screen and not dying and should_shoot:
		shoot_lasers()
		emit_signal("shot")
