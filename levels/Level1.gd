extends Level

export var cloud_timer_min := 3.0
export var cloud_timer_max := 12.0
export var cloud_scale_rand := 0.5

export(Array, Texture) var cloud_types : Array
export var cloud_speed := 100

onready var cloud_timer := $CloudTimer

func _ready():
	spawn_random_cloud()
	start_timer()
	randomize()

func start_timer():
	cloud_timer.start(cloud_timer_min + randf() * cloud_timer_max)

func spawn_random_cloud():
	var cloud : Sprite = preload("res://clouds/Cloud.tscn").instance()
	cloud.init(Vector2(0, cloud_speed * randf() * .1 + cloud_speed ))
	var rand = randi() % cloud_types.size()
	cloud.texture = cloud_types[rand]
	cloud.position.y = -cloud.texture.get_size().y * cloud.scale.y
	$Clouds.add_child(cloud)

func _on_CloudTimer_timeout():
	spawn_random_cloud()
	start_timer()
