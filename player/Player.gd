extends KinematicBody2D

class_name Player

signal died(killer)

export var acceleration := 1500
export var deceleration := 3000
export var max_speed := 500

export(RectangleShape2D) var keep_in_rect : RectangleShape2D


var vel := Vector2.ZERO

var invincible := false
var lock := false


onready var anim_player = $AnimationPlayer
onready var resawn_timer = $RespawnTimer
onready var invin_timer = $InvincibilityTimer

onready var spawn_position := position

func _ready():
	respawn()

func _physics_process(delta):
	var move_dir := get_move_dir()
	if move_dir == Vector2.ZERO:
		apply_friction(deceleration * delta)
		anim_player.play("fly_straight")
	else:
		apply_movement(move_dir * acceleration * delta)
		if move_dir.x > 0:
			anim_player.play("fly_right")
		elif move_dir.x < 0:
			anim_player.play("fly_left")
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
		position.x -= spawn_dist.normalized().x * pow(abs(spawn_dist.x)-keep_in_rect.extents.x, 1.5) * delta
	if abs(spawn_dist.y) > keep_in_rect.extents.y:
		position.y -= spawn_dist.normalized().y * pow(abs(spawn_dist.y)-keep_in_rect.extents.y, 1.5) * delta

func die():
	anim_player.play("die")
	resawn_timer.start()

func respawn():
	anim_player.play("respawn")
	invincible = true
	lock = true
	invin_timer.start()

func apply_movement(acceleration : Vector2):
	vel += acceleration
	if vel.length() > max_speed:
		vel = vel.normalized() * max_speed

func apply_friction(amount : float):
	if vel.length() > amount:
		vel -= vel.normalized() * amount
	else:
		vel = Vector2.ZERO
		

func _on_RespawnTimer_timeout():
	respawn()

func _on_InvincibilityTimer_timeout():
	invincible = false


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "respawn":
		lock = false
