extends Character

class_name Enemy

export var onscreen_speed := 450.0
export var offscreen_speed := 50

export var shot_speed := 400
export var init_delay := 1.5
export var shoot_delay := 3

export var should_shoot := true

var on_screen := false
var left_screen := false
onready var speed := offscreen_speed

onready var shoot_timer := $ShootTimer

# to be overwritten - used to move the enemy while on screen - called each process
func move(delta):
	pass

# to be overwritten - called when the enemy is on screen and the shoot timer ran out
func shoot():
	pass

func _ready():
	shoot_timer.wait_time = shoot_delay

func _physics_process(delta):
	if not dying:
		if not on_screen:
			move_offscreen(delta)
		else:
			move(delta)
	if (left_screen or dead) and bullet_spawn.get_child_count() == 0:
		queue_free()

func move_offscreen(delta):
	position += offscreen_speed * delta

func _on_VisibilityNotifier2D_screen_entered():
	speed = onscreen_speed
	on_screen = true
	shoot_timer.start(init_delay)
	$Collider.disabled = false

func _on_VisibilityNotifier2D_screen_exited():
	on_screen = false
	left_screen = true
	$Collider.disabled = true
	#queue_free()

func anim_finished(anim_name):
	pass

func queue_free():
	print("freed enemy")
	.queue_free()

func _on_ShootTimer_timeout():
	if on_screen and not dying and should_shoot:
		shoot()
