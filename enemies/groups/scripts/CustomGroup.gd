extends EnemyGroup

func pre_construct():
	amount = get_child_count()

func construct(num : int) -> Enemy:
	var enemy = get_child(num)
	return enemy
