extends Character

class_name Enemy

export var points := 10

export var onscreen_speed := 250.0
export var offscreen_speed := 50

export var first_shot_delay := 1.1

export var should_shoot := true setget set_shoot

export(Array, PackedScene) var power_up_drops := [preload("res://src/power-ups/BiggerBullets.tscn")]
export(Array, float) var power_up_chances := [.1]

var on_screen := false
var left_screen := false

onready var shoot_timer := $ShootTimer
onready var enemy_anims : AnimationPlayer = $EnemyAnimations

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
	enemy_anims.play("fly")

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

func shoot_at_player(projectile : Projectile):
	shoot_at(Globals.player.get_node("Collider").global_position, projectile)

func drop_random_power_up(chance_factor : float):
	var drops := []
	for i in range(power_up_drops.size()):
		if randf() <= power_up_chances[i]:
			drops.append(power_up_drops[i])
	if drops.size() > 0:
		drop_power_up(drops[randi() % drops.size()])

func drop_power_up(power_up : PackedScene):
	var drop : Area2D = power_up.instance()
	drop.global_position = global_position
	Globals.level_objects.call_deferred("add_child", drop)


func screen_entered():
	on_screen = true
	if should_shoot:
		shoot_timer.start(first_shot_delay)
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
		shoot_timer.start(first_shot_delay)
	if not enabled and should_shoot:
		shoot_timer.stop()
	should_shoot = enabled


func _on_ShootTimer_timeout():
	if on_screen and not dying and should_shoot:
		shoot()

func _on_Enemy_died(killer : Node2D):
	if killer.is_in_group("player"):
		drop_random_power_up(1)
