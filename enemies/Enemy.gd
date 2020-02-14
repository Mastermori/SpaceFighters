extends Character

class_name Enemy

export var onscreen_speed := 250.0
export var offscreen_speed := 50

export var shot_speed := 400
export var init_delay := 1.1
export var shoot_delay := 2

export var should_shoot := true setget set_shoot

var on_screen := false
var left_screen := false

onready var shoot_timer := $ShootTimer

# to be overwritten - used to move the enemy while on screen - called each process
func move(_delta):
	pass

# to be overwritten - called when the enemy is on screen and the shoot timer ran out
func shoot():
	pass

# to be overwritten - called when the enemy is entered the screen
func enter_screen():
	pass

# to be overwritten - called when the enemy is exited the screen
func exit_screen():
	pass


func _ready():
	shoot_timer.wait_time = shoot_delay

func _physics_process(delta):
	process_bounds()
	process_movement(delta)
	process_death()

func process_movement(delta):
	if not dying and not left_screen:
		if on_screen:
			move(delta)
		else:
			move_offscreen(delta)

func process_bounds():
	var in_bounds := check_bounds(0, -10, window_width, window_height)
	if not on_screen and not left_screen:
		if in_bounds:
			screen_entered()
	if on_screen and not in_bounds and global_position.y > 10:
		screen_left()

func process_death():
	if (left_screen or dead) and no_bullets():
		queue_free()

func no_bullets() -> bool:
	for spawn in bullet_spawns.get_children():
		if not spawn.get_child_count() == 0:
			return false
	return true

func move_offscreen(delta):
	position.y += offscreen_speed * delta

func shoot_at(global_pos : Vector2, projectile : Projectile):
	var dir = (global_pos - global_position).normalized()
	shoot_projectile(projectile, dir * shot_speed)

func shoot_at_player(projectile : Projectile):
	shoot_at(Globals.player.get_node("Collider").global_position, projectile)


func screen_entered():
	on_screen = true
	if should_shoot:
		shoot_timer.start(init_delay)
	$Collider.set_deferred("disabled", false)
	enter_screen()

func screen_left():
	on_screen = false
	left_screen = true
	$Collider.set_deferred("disabled", true)
	if should_shoot:
		should_shoot = false
	exit_screen()

func queue_free():
	.queue_free()

func set_shoot(enabled : bool):
	if enabled and not should_shoot and on_screen:
		shoot_timer.start(init_delay)
	if not enabled and should_shoot:
		shoot_timer.stop()
	should_shoot = enabled

func _on_ShootTimer_timeout():
	if on_screen and not dying and should_shoot:
		shoot()
