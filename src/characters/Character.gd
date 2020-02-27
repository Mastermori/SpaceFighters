extends KinematicBody2D

class_name Character

signal died(killer)
signal health_changed(health, last_health, max_health)
signal shot()

export var acceleration := 1500
export var deceleration := 3000

export var max_speed := 500
export var max_health := 100.0

export(Globals.Factions) var faction := Globals.Factions.NEUTRAL

export var shot_speed := 800.0
export var shoot_delay := .15
export var bullet_size := Vector2.ONE setget set_bullet_size
export var bullet_damage_scale := 1.0 setget set_bullet_damage_scale

export var shot_sound_varient := 0

var vel := Vector2.ZERO
var force_vel := Vector2.ZERO
var last_damaged_by
var dead := false
var dying := false
onready var health := max_health setget set_health

var power_ups := {}

onready var character_anims : AnimationPlayer = $CharacterAnimations
onready var sprite : Sprite = $Sprite
onready var bullet_spawns : Node2D = $BulletSpawns
onready var collider : CollisionObject2D = $Collider
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
func shoot_projectile(projectile : Projectile, vel : Vector2, damage := -1, bullet_spawn_name : String = "Middle"):
	projectile.init(vel, self)
	projectile.scale *= bullet_size
	if not damage == -1:
		projectile.damage = damage
	projectile.damage *= bullet_damage_scale
	projectile.set_as_toplevel(true)
	var bullet_spawn = bullet_spawns.get_node(bullet_spawn_name)
	projectile.rotation = vel.angle()
	projectile.global_position = bullet_spawn.global_position
	bullet_spawn.add_child(projectile)
	projectile.connect("hit", self, "projectile_hit")
	Globals.play_sound("shoot", shot_sound_varient, self, false, -40, randf() / 2 + .75 - bullet_size.x / 4)

func shoot_at(projectile : Projectile, global_pos : Vector2, damage := -1, shot_speed := self.shot_speed, bullet_spawn_name : String = "Middle"):
	var dir = (global_pos - global_position).normalized()
	shoot_dir(projectile, dir, damage, shot_speed, bullet_spawn_name)

func shoot_dir(projectile : Projectile, dir : Vector2, damage := -1, shot_speed := self.shot_speed, bullet_spawn_name : String = "Middle"):
	shoot_projectile(projectile, dir * shot_speed, damage, bullet_spawn_name)

func take_damage(amount : float, caused_by):
	self.health -= amount
	last_damaged_by = caused_by
	if health <= 0:
		if not dying:
			die()
	else:
		character_anims.play("hit")

func set_health(amount : float):
	emit_signal("health_changed", amount, health, max_health)
	health = amount

func die():
	dying = true
	character_anims.play("die")
	collider.set_deferred("disabled", true)
	Globals.play_random_sound("explosion", self, true, -20, randf() / 5 + .9)
	emit_signal("died", last_damaged_by)

# warning-ignore:shadowed_variable
func apply_movement(acceleration : Vector2):
	vel += acceleration
	if vel.length() > max_speed:
		vel = vel.normalized() * max_speed

func check_bounds(minx, miny, maxx, maxy) -> bool:
	var in_x : bool = global_position.x + sprite.get_rect().end.x > minx and global_position.x + sprite.get_rect().position.x < maxx
	var in_y : bool = global_position.y + sprite.get_rect().end.y > miny and global_position.y + sprite.get_rect().position.y < maxy
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

func add_power_up(name : String, power_up : Node2D, time : float):
	# Reset timer if power-up already collected
	if power_ups.has(name):
		power_ups[name][1].start()
		return
	
	# Add power-up to node
	add_child(power_up)
	power_up.owner = self
	power_up.apply_modifiers()
	connect("shot", power_up, "on_shot")
	
	# Create timer to remove power-up
	var timer := Timer.new()
	timer.name = name + "Timer"
	timer.wait_time = time
	timer.one_shot = true
	power_up.add_child(timer)
	timer.connect("timeout", self, "remove_power_up", [name])
	timer.start()
	timer.owner = power_up
	
	# Add power-up to list
	power_ups[name] = [power_up, timer]

func remove_power_up(name):
	var power_up = power_ups[name]
	
	# Remove power-up node
	disconnect("shot", power_up[0], "on_shot")
	power_up[0].remove_modifiers()
	power_up[0].queue_free()
	
	# Remove timer
	power_up[1].stop()
	power_up[1].queue_free()
	power_ups.erase(name)


func _on_CharacterAnimations_animation_finished(anim_name):
	if anim_name == "die":
		dead = true
