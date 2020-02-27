extends Enemy

class_name BigBoy

export var center_position := Vector2(303, 300)
export var move_x_bounds := 100

export var rocket_delay := 1.5

export var lasers_delay := 1.0
export var laser_count := 3

var rocket_counter := 0
var laser_counter := 0
var biggy_counter := 0

var move_dir := 0

onready var rocket_timer := $RocketTimer
onready var laser_timer := $LaserTimer

func _ready():
	randomize()

func move(delta):
	if position.y < center_position.y:
		vel = Vector2.DOWN * 2
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
	rocket_timer.start(rocket_delay)
	laser_timer.start(lasers_delay)

func shoot():
	biggy_counter += 1
	if biggy_counter > 2:
		bullet_size += Vector2(3, 3)
		bullet_damage_scale += 1
	shoot_at_player(preload("res://src/projectiles/EnemyProjectile.tscn").instance(), 30, self.shot_speed/2)
	if biggy_counter > 2:
		bullet_size -= Vector2(3, 3)
		bullet_damage_scale -= 1
		biggy_counter = 0
#	shoot_dir(preload("res://src/projectiles/LaserProjectile.tscn").instance(), Vector2.DOWN)

func shoot_rockets():
#	print("ROCKETS!!!")
	pass

func shoot_lasers():
	bullet_size *= .7
	for i in range(laser_count):
		shoot_laser(Vector2.DOWN.rotated(i * 1.0 / laser_count - .25), "LeftLasers")
		shoot_laser(Vector2.DOWN.rotated(i * 1.0 / laser_count - .25), "RightLasers")
	bullet_size /= .7


func shoot_laser(dir : Vector2, spawn_name : String):
	shoot_projectile(preload("res://src/projectiles/LaserProjectile.tscn").instance(), dir * (self.shot_speed*1.2), 15, spawn_name)


func _on_RocketTimer_timeout():
	if on_screen and not dying and should_shoot:
		shoot_rockets()
		emit_signal("shot")

func _on_LaserTimer_timeout():
	if on_screen and not dying and should_shoot:
		shoot_lasers()
		emit_signal("shot")
