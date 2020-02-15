extends Area2D

class_name PowerUp

export var move_speed := 50

onready var anim_player := $AnimationPlayer

# to be overwritten in children
func give_powerup():
	pass

func _ready():
	anim_player.play("default")

func _physics_process(delta):
	position += Vector2.DOWN * move_speed


func _on_PowerUp_body_entered(body : KinematicBody2D):
	if body is Player:
		give_powerup()
