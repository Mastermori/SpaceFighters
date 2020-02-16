extends Area2D

class_name Projectile

signal hit(enemy)

export var damage := 10.0

var vel := Vector2.ZERO
var faction : int

onready var origin : KinematicBody2D

func init(vel : Vector2, owner : KinematicBody2D):
	self.vel = vel
	origin = owner
	faction = origin.faction

func _physics_process(delta):
	position += vel * delta

func hit(body : KinematicBody2D):
	body.take_damage(damage, origin)
	emit_signal("hit", body)
	queue_free()


func _on_Projectile_body_entered(body : CollisionObject2D):
	if body == origin:
		return
	if body.is_in_group("obstacle"):
		hit(body)
	if not "faction" in body:
		return
	if body.faction == Globals.Factions.NEUTRAL:
		hit(body)
	if not body.faction == faction:
		hit(body)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
