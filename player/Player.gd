extends Character

class_name Player

export(RectangleShape2D) var keep_in_rect : RectangleShape2D
export var shot_speed := 400.0
export var shoot_delay := .15


var lock := false


onready var resawn_timer : Timer = $RespawnTimer
onready var invin_timer : Timer = $InvincibilityTimer
onready var sprite : Sprite = $Sprite
onready var player_anims := $PlayerAnimations
onready var shoot_timer := $ShootTimer

onready var spawn_position := position

func _ready():
	Globals.player = self
	respawn()

func _physics_process(delta):
	if not lock:
		var move_dir := get_move_dir()
		if move_dir == Vector2.ZERO:
			apply_friction(deceleration * delta)
			player_anims.play("fly_straight")
		else:
			apply_movement(move_dir * acceleration * delta)
			if move_dir.x > 0:
				if vel.x > max_speed * .9:
					player_anims.play("fly_right")
				else:
					player_anims.play("fly_right_slight")
			elif move_dir.x < 0:
				if vel.x < -max_speed * .9:
					player_anims.play("fly_left")
				else:
					player_anims.play("fly_left_slight")
			else:
				player_anims.play("fly_straight")
		keep_in_bounds(delta)
		move_and_collide(vel * delta)
		
		if Input.is_action_pressed("player_shoot") and shoot_timer.is_stopped():
			shoot_projectile(preload("res://projectiles/OrangeProjectile.tscn").instance(), Vector2.UP * shot_speed)
			shoot_timer.start(shoot_delay)

func get_move_dir() -> Vector2:
	var dir := Vector2.ZERO
	dir.x += Input.get_action_strength("player_right") - Input.get_action_strength("player_left")
	dir.y += Input.get_action_strength("player_down") - Input.get_action_strength("player_up")
	return dir

func keep_in_bounds(delta):
	var spawn_dist = position - spawn_position
	if abs(spawn_dist.x) > keep_in_rect.extents.x:
		position.x -= sign(spawn_dist.x) * pow(abs(spawn_dist.x)-keep_in_rect.extents.x, 1.5) * delta
	if abs(spawn_dist.y) > keep_in_rect.extents.y:
		position.y -= sign(spawn_dist.y) * pow(abs(spawn_dist.y)-keep_in_rect.extents.y, 1.5) * delta

func die():
	print("player died to " + last_damaged_by.name)
	resawn_timer.start()
	.die()

func respawn():
	character_anims.play("respawn")
	player_anims.play("fly_straight")
	health = max_health
	lock = true
	invin_timer.start()


func _on_RespawnTimer_timeout():
	respawn()
	print("player respawning")

func _on_InvincibilityTimer_timeout():
	$Collider.set_deferred("disabled", false)

func anim_finished(anim_name):
	if anim_name == "respawn":
		lock = false
	else:
		print(anim_name + " just finished on Player")
