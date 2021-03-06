extends Area2D

class_name PowerUp

export var move_speed := 100
export var duration := 5
export var attacher : GDScript

var is_dropping := false
var vel := Vector2.ZERO

onready var anim_player := $AnimationPlayer
onready var move_timer := $MoveTimer


func _ready():
	anim_player.play("default")

func _physics_process(delta):
	if is_dropping:
		vel += Vector2.DOWN * delta
		position += vel * move_speed * delta
	else:
		position.y += sin(move_timer.time_left * 4) / 2
		var max_time = move_timer.wait_time
		var time = move_timer.time_left
		if time < max_time / 3:
			anim_player.playback_speed = range_lerp(time, max_time / 3, 0, 1, 4)

func _on_PowerUp_body_entered(body : KinematicBody2D):
	if body is Player:
		if attacher == null:
			print("ERROR: power-up has no attacher to attach to character!")
		else:
			var attacher_inst = attacher.new()
			attacher_inst.attach(body, duration)
		set_physics_process(false)
		anim_player.playback_speed = 1
		anim_player.play("collect")

func _on_MoveTimer_timeout():
	is_dropping = true


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "collect":
		queue_free()
