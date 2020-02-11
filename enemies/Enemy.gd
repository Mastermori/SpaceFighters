extends Character

class_name Enemy

export var onscreen_speed := 450.0
export var offscreen_speed := 50

export var shot_speed := 400
export var init_delay := 1.5
export var shoot_delay := 3

var speed := offscreen_speed
var on_screen := false
var left_screen := false

onready var follow : PathFollow2D = get_parent()
onready var shoot_timer := $ShootTimer

func _ready():
	shoot_timer.wait_time = shoot_delay

func _process(delta):
	if not dying:
		follow.offset += speed * delta
	if (left_screen or dead) and bullet_spawn.get_child_count() == 0:
		queue_free()

func _on_VisibilityNotifier2D_screen_entered():
	speed = onscreen_speed
	on_screen = true
	shoot_timer.start(init_delay)

func _on_VisibilityNotifier2D_screen_exited():
	on_screen = false
	left_screen = true
	#queue_free()

func anim_finished(anim_name):
	pass

func queue_free():
	print("freed enemy")
	.queue_free()

func _on_ShootTimer_timeout():
	if on_screen and not dying:
		var dir = (Globals.player.get_node("Collider").global_position - global_position).normalized()
		shoot(preload("res://projectiles/PinkProjectile.tscn").instance(), dir * shot_speed)
