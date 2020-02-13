extends YSort

class_name EnemyGroup

export(PackedScene) var enemy_scene

export var amount := 3

export var offset := Vector2.ZERO
export var offset_step := Vector2.ZERO
export var offset_mask := Vector2.ZERO

func _ready():
	if global_position.y >= 0:
		print("ERROR: Enemy groups must be located above the level")
	print("Group position: " + str(global_position))
	for i in range(amount):
		var enemy : Enemy = construct()
		enemy.position = offset * i + offset_step * offset_mask * i
		add_child(enemy)
		print("Enemy" + str(i) + " position: " + str(enemy.global_position))

func construct() -> Enemy:
	return enemy_scene.instance()
