extends KinematicBody2D

class_name Player

signal died(killer)

export var acceleration := 1500
export var deceleration := 3000
export var max_speed := 500

var invincible := false

var vel := Vector2.ZERO

var lock := false

onready var anim_player = $AnimationPlayer
onready var resawn_timer = $RespawnTimer
onready var invin_timer = $InvincibilityTimer


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
	vel = move_and_slide(vel)

func get_move_dir() -> Vector2:
	var dir := Vector2.ZERO
	dir.x += Input.get_action_strength("player_right") - Input.get_action_strength("player_left")
	dir.y += Input.get_action_strength("player_down") - Input.get_action_strength("player_up")
	return dir

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
