extends Node2D

export var cloud_timer_min := 1.0
export var cloud_timer_max := 3.0
export var cloud_scale_rand := 0.5

export(Array, Texture) var cloud_types : Array
export var cloud_speed := 200

onready var cloud_timer := $CloudTimer

func _ready():
	print("Ready Level")
	start_timer()

func start_timer():
	cloud_timer.start(cloud_timer_min + randf() * cloud_timer_max)

func _on_CloudTimer_timeout():
	var cloud : TextureRect = preload("res://clouds/Cloud.tscn").instance()
	cloud.init(Vector2(cloud_speed, 0))
	cloud.texture = cloud_types[randi() % cloud_types.size()]
	cloud.rect_position.y = -cloud.rect_size.y
	$Clouds.add_child(cloud)
	start_timer()
	print("Cloud")
