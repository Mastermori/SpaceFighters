extends KinematicBody2D

class_name Character

signal died(killer)

export var acceleration := 1500
export var deceleration := 3000
export var max_speed := 500
export var max_health := 100.0
export(Globals.Factions) var faction := Globals.Factions.NEUTRAL

var vel := Vector2.ZERO
var last_damaged_by
var dead := false
var dying := false
onready var health := max_health

onready var character_anims : AnimationPlayer = $CharacterAnimations
onready var bullet_spawn : Position2D = $BulletSpawn
onready var sprite : Sprite = $Sprite
onready var window_width : int = ProjectSettings.get("display/window/size/width")
onready var window_height : int = ProjectSettings.get("display/window/size/height")

# to be overwritten - called when any Animation is finished
func anim_finished(anim_name):
	pass

func _ready():
	for node in get_children():
		if node is AnimationPlayer:
			node.connect("animation_finished", self, "anim_finished")

func shoot_projectile(projectile : Projectile, vel : Vector2):
	projectile.init(vel, self)
	projectile.set_as_toplevel(true)
	projectile.global_position = bullet_spawn.global_position
	bullet_spawn.add_child(projectile)

func take_damage(amount : float, caused_by):
	health -= amount
	last_damaged_by = caused_by
	if health <= 0:
		die()
	else:
		character_anims.play("hit")

func die():
	dying = true
	character_anims.play("die")
	$Collider.set_deferred("disabled", true)
	emit_signal("died", last_damaged_by)

func apply_movement(acceleration : Vector2):
	vel += acceleration
	if vel.length() > max_speed:
		vel = vel.normalized() * max_speed

func check_bounds(minx, miny, maxx, maxy) -> bool:
	var in_x : bool = global_position.x + sprite.texture.get_size().x > minx and global_position.x < maxx
	var in_y : bool = global_position.y + sprite.texture.get_size().y > miny and global_position.y < maxy
	return in_x and in_y

func apply_friction(amount : float):
	if vel.length() > amount:
		vel -= vel.normalized() * amount
	else:
		vel = Vector2.ZERO

func _on_CharacterAnimations_animation_finished(anim_name):
	if anim_name == "die":
		dead = true
