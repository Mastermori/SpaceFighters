extends Character

class_name Player

export(RectangleShape2D) var keep_in_rect : RectangleShape2D
export var shot_speed := 800.0
export var shoot_delay := .15
export var use_mouse_movement := false
export var stop_distance := 20


var lock := false


onready var resawn_timer : Timer = $RespawnTimer
onready var invin_timer : Timer = $InvincibilityTimer
onready var player_anims := $PlayerAnimations
onready var shoot_timer := $ShootTimer

onready var spawn_position := position

func _ready():
	Globals.player = self
	respawn()

func _physics_process(delta):
	if not lock:
		
		
		if Input.is_action_pressed("player_shoot") and shoot_timer.is_stopped():
			shoot_projectile(preload("res://projectiles/OrangeProjectile.tscn").instance(), Vector2.UP * shot_speed)
			shoot_timer.start(shoot_delay)

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

func _on_InvincibilityTimer_timeout():
	$Collider.set_deferred("disabled", false)

func anim_finished(anim_name):
	if anim_name == "respawn":
		lock = false
