extends KinematicBody2D

class_name Character

signal died(killer)
signal health_changed(health, last_health, max_health)

export var acceleration := 1500
export var deceleration := 3000
export var max_speed := 500
export var max_health := 100.0
export(Globals.Factions) var faction := Globals.Factions.NEUTRAL
export var shot_speed := 800.0
export var shoot_delay := .15
export var bullet_size := Vector2.ONE setget set_bullet_size
export var bullet_damage_scale := 1.0 setget set_bullet_damage_scale

var vel := Vector2.ZERO
var force_vel := Vector2.ZERO
var last_damaged_by
var dead := false
var dying := false
onready var health := max_health

var power_ups := {}

onready var character_anims : AnimationPlayer = $CharacterAnimations
onready var sprite : Sprite = $Sprite
onready var bullet_spawns : Node2D = $BulletSpawns
onready var window_width : int = ProjectSettings.get("display/window/size/width")
onready var window_height : int = ProjectSettings.get("display/window/size/height")

# to be overwritten - called when any Animation is finished
func anim_finished(_anim_name):
	pass

# to be overwritten - called when a projectile shot by this character hits something
func projectile_hit(body : KinematicBody2D):
	pass

func _ready():
	for node in get_children():
		if node is AnimationPlayer:
			node.connect("animation_finished", self, "anim_finished")

# warning-ignore:shadowed_variable
func shoot_projectile(projectile : Projectile, vel : Vector2, bullet_spawn : Position2D = bullet_spawns.get_children()[0]):
	projectile.init(vel, self)
	projectile.scale *= bullet_size
	projectile.damage *= bullet_damage_scale
	projectile.set_as_toplevel(true)
	projectile.global_position = bullet_spawn.global_position
	projectile.connect("hit", self, "projectile_hit")
	bullet_spawn.add_child(projectile)

func shoot_at(global_pos : Vector2, projectile : Projectile):
	var dir = (global_pos - global_position).normalized()
	shoot_projectile(projectile, dir * shot_speed)

func take_damage(amount : float, caused_by):
	health -= amount
	last_damaged_by = caused_by
	emit_signal("health_changed", health, health + amount, max_health)
	if health <= 0:
		if not dying:
			die()
	else:
		character_anims.play("hit")

func die():
	dying = true
	character_anims.play("die")
	$Collider.set_deferred("disabled", true)
	emit_signal("died", last_damaged_by)

# warning-ignore:shadowed_variable
func apply_movement(acceleration : Vector2):
	vel += acceleration
	if vel.length() > max_speed:
		vel = vel.normalized() * max_speed

func check_bounds(minx, miny, maxx, maxy) -> bool:
	var in_x : bool = global_position.x + sprite.texture.get_size().x / 2 > minx and global_position.x - sprite.texture.get_size().x / 2 < maxx
	var in_y : bool = global_position.y + sprite.texture.get_size().y / 2 > miny and global_position.y - sprite.texture.get_size().y / 2 < maxy
	return in_x and in_y

func apply_impulse():
	pass

func apply_friction(amount : float):
	if vel.length() > amount:
		vel -= vel.normalized() * amount
	else:
		vel = Vector2.ZERO
	if force_vel.length() > amount:
		force_vel -= force_vel.normalized() * amount
	else:
		force_vel = Vector2.ZERO

func set_bullet_size(size : Vector2):
	bullet_size = size

func set_bullet_damage_scale(damage_scale : float):
	bullet_damage_scale = damage_scale

func set_later(var_name : String, val, time : float):
	yield(get_tree().create_timer(time), "timeout")
	set(var_name, val)

func add_power_up(name : String, var_names : Array, values : Array, time : float):
	if not var_names.size() == values.size():
		print("Tried to add power up with uneven vars and vals to " + self.name)
		return
	if power_ups.has(name):
		power_ups[2].start()
	for i in range(var_names.size()):
		var var_name : String = var_names[i]
		var value = values[i]
		set(var_name, get(var_name) + value)
	var timer := Timer.new()
	timer.name = name + "Timer"
	timer.wait_time = time
	timer.one_shot = false
	add_child(timer)
	timer.connect("timeout", self, "remove_power_up", [name])
	timer.start()
	power_ups[name] = [var_names, values, timer]

func remove_power_up(name):
	var power_up = power_ups[name]
	for i in range(power_up[0].size()):
		var var_name : String = power_up[0][i]
		var value = power_up[1][i]
		set(var_name, get(var_name) - value)
	power_up[2].stop()
	power_up[2].queue_free()
	power_ups.erase(name)
	print("removed power-up: " + name)


func _on_CharacterAnimations_animation_finished(anim_name):
	if anim_name == "die":
		dead = true
