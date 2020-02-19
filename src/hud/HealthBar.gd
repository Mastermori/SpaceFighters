extends TextureProgress

onready var tween := $Tween

func _on_Character_health_changed(health, last_health, max_health):
	tween.interpolate_property(self, "value", value, health, .5, Tween.TRANS_CUBIC, Tween.EASE_IN)
	tween.start()
#	value = health / max_health * 100
