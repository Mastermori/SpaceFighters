extends PowerUp

func give_powerup(player : Player):
	player.add_power_up("bigger_bullets", ["bullet_size", "bullet_damage_scale"], [Vector2(1, 1), .5], 5)
