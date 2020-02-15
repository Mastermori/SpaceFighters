extends YSort

class_name EnemyGroup

export(PackedScene) var enemy_scene

export var amount := 3

export var offset := Vector2.ZERO
export var offset_step := Vector2.ZERO
export var offset_mask := Vector2.ZERO
export var custom_rotation := 0

func _ready():
	if global_position.y >= 0:
		print("ERROR: Enemy groups must be located above the level")
	pre_construct()
	for i in range(amount):
		var enemy = construct(i)
		enemy.position = offset * i + offset_step * offset_mask * i
		enemy.rotation_degrees = custom_rotation
		if not enemy in get_children():
			add_child(enemy)

func pre_construct():
	pass

func construct(num : int) -> Enemy:
	return enemy_scene.instance()
