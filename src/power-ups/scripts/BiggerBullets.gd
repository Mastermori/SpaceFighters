extends PowerUpAttach

export var bullet_scale := Vector2(2, 1.5)
export var damage_scale_add := .5

func apply_modifiers():
	print("applied modifiers")
	attached_to.bullet_size += bullet_scale
	attached_to.bullet_damage_scale += damage_scale_add

func remove_modifiers():
	print("removed modifiers")
	attached_to.bullet_size -= bullet_scale
	attached_to.bullet_damage_scale -= damage_scale_add
