extends Character

class_name Player

export(RectangleShape2D) var keep_in_rect : RectangleShape2D
export var move_speed := 10


onready var resawn_timer : Timer = $RespawnTimer
onready var invin_timer : Timer = $InvincibilityTimer
onready var player_anims := $PlayerAnimations
onready var shoot_timer := $ShootTimer

onready var spawn_position := position


func _ready():
	Globals.player = self
	respawn()

func _physics_process(delta):
	if not dying:
		var mouse_pos := get_global_mouse_position()
		var dist = global_position - mouse_pos
		
		var new_pos : Vector2
		if dist.length() > max_speed:
			new_pos = lerp(global_position, global_position - dist.normalized() * max_speed, move_speed * delta)
			if dist.x > 0:
				player_anims.play("fly_left_slight")
			else:
				player_anims.play("fly_right_slight")
		else:
			new_pos = lerp(global_position, mouse_pos, move_speed * delta)
			if dist.length() > max_speed * .4:
				if dist.x > 0:
					player_anims.play("fly_left_slight")
				else:
					player_anims.play("fly_right_slight")
			else:
				player_anims.play("fly_straight")
		new_pos.x = clamp(new_pos.x, 0, window_width)
		global_position = new_pos
		
		if Input.is_action_pressed("player_shoot") and shoot_timer.is_stopped():
			shoot_dir(preload("res://src/projectiles/PlayerProjectile.tscn").instance(), Vector2.UP)
			shoot_timer.start(shoot_delay)
			emit_signal("shot")

func keep_in_bounds(delta):
	var spawn_dist = position - spawn_position
	if abs(spawn_dist.x) > keep_in_rect.extents.x:
		vel.x -= sign(spawn_dist.x) * pow(abs(spawn_dist.x)-keep_in_rect.extents.x, 1.5) * delta
	if abs(spawn_dist.y) > keep_in_rect.extents.y:
		vel.y -= sign(spawn_dist.y) * pow(abs(spawn_dist.y)-keep_in_rect.extents.y, 1.5) * delta

func die():
	print("player died to " + last_damaged_by.name)
	resawn_timer.start()
	.die()

func respawn():
	character_anims.play("respawn")
	player_anims.play("fly_straight")
	self.health = max_health
	dying = false
	dead = false
	position = spawn_position
	invin_timer.start()


func _on_RespawnTimer_timeout():
	respawn()

func _on_InvincibilityTimer_timeout():
	collider.set_deferred("disabled", false)

func anim_finished(anim_name):
	pass
