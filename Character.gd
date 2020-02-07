extends KinematicBody2D

class_name Character

signal died(killer)

export var acceleration := 1500
export var deceleration := 3000
export var max_speed := 500
export var max_health := 100.0

var vel := Vector2.ZERO
var last_damaged_by
var health := max_health

onready var anim_player := $AnimationPlayer


func take_damage(amount : float, caused_by):
	health -= amount
	last_damaged_by = caused_by
	if health <= 0:
		die()
	else:
		if anim_player:
			anim_player.play("hit")

func die():
	if anim_player:
		anim_player.play("die")
	emit_signal("died", last_damaged_by)

func apply_movement(acceleration : Vector2):
	vel += acceleration
	if vel.length() > max_speed:
		vel = vel.normalized() * max_speed

func apply_friction(amount : float):
	if vel.length() > amount:
		vel -= vel.normalized() * amount
	else:
		vel = Vector2.ZERO
