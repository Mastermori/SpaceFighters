extends Character

class_name Player

export(RectangleShape2D) var keep_in_rect : RectangleShape2D


var invincible := false
var lock := false


onready var resawn_timer : Timer = $RespawnTimer
onready var invin_timer : Timer = $InvincibilityTimer
onready var sprite : Sprite = $Sprite

onready var spawn_position := position

func _ready():
	respawn()

func _physics_process(delta):
	if not lock:
		var move_dir := get_move_dir()
		if move_dir == Vector2.ZERO:
			apply_friction(deceleration * delta)
			anim_player.play("fly_straight")
		else:
			apply_movement(move_dir * acceleration * delta)
			if move_dir.x > 0:
				if vel.x > max_speed * .9:
					anim_player.play("fly_right")
				else:
					anim_player.play("fly_right_slight")
			elif move_dir.x < 0:
				if vel.x < -max_speed * .9:
					anim_player.play("fly_left")
				else:
					anim_player.play("fly_left_slight")
			else:
				anim_player.play("fly_straight")
		keep_in_bounds(delta)
		vel = move_and_slide(vel)

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
	resawn_timer.start()
	.die()

func respawn():
	sprite.frame = 2
	anim_player.play("respawn")
	invincible = true
	lock = true
	invin_timer.start()


func _on_RespawnTimer_timeout():
	respawn()

func _on_InvincibilityTimer_timeout():
	invincible = false


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "respawn":
		lock = false
