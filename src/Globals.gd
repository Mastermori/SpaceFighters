extends Node

enum Factions {
	PLAYER,
	ALIENS,
	NEUTRAL,
}

const sounds : Dictionary = {}

var player : KinematicBody2D
var level : Level setget set_level
var level_objects : YSort

var sound_level : float setget set_sound_level

func _ready():
	sounds["shoot"] = get_sounds_from_dir("shoot")
	sounds["hit"] = get_sounds_from_dir("hit")
	sounds["explosion"] = get_sounds_from_dir("explosion")

func get_sounds_from_dir(name : String, path := "res://assets/sounds/") -> Array:
	var dir = Directory.new()
	var sounds_from_dir := []
	path = path + name + "/"
	if dir.open(path) == OK:
		dir.list_dir_begin(true)
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with("wav"):
				sounds_from_dir.append(load(path + file_name))
			file_name = dir.get_next()
		return sounds_from_dir
	else:
		print("An error occurred when trying to access the path.")
		return []

func change_level(l : Node):
	set_level(l)
	change_scene(l, false)

func find_level(level_name : String):
	var level_inst = load("res://src/levels/" + level_name + ".tscn").instance()
	change_level(level_inst)

func change_scene(new_scene : Node, clear_level := true):
	var root = get_tree().get_root()
	var current = get_tree().current_scene
	if clear_level:
		level = null
	root.remove_child(current)
	current.call_deferred("free")
	root.add_child(new_scene)
	# Optional, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(new_scene)

func play_random_sound(sound : String, parent : Node, is_positional := true, volume_db := 0.0, pitch_scale := 1.0, bus := "SFX") -> void:
	play_sound(sound, randi() % sounds[sound].size(), parent, is_positional, volume_db, pitch_scale, bus)

func play_sound(sound : String, sound_index : int, parent : Node, is_positional := true, volume_db = 0.0, pitch_scale = 1.0, bus = "SFX") -> void:
	var audio_stream_player : Node
	if is_positional:
		audio_stream_player = AudioStreamPlayer2D.new()
	else:
		audio_stream_player = AudioStreamPlayer.new()
	
	parent.add_child(audio_stream_player)
	audio_stream_player.bus = bus
	audio_stream_player.stream = sounds[sound][sound_index]
	audio_stream_player.volume_db = volume_db
	audio_stream_player.pitch_scale = pitch_scale
	audio_stream_player.play()
	audio_stream_player.connect("finished", audio_stream_player, "queue_free")


func set_level(l : Level):
	print("set level")
	level = l
	level_objects = l.get_node("Objects")

func set_sound_level(value : float):
	if value > 1:
		print("Sound level can't be set above 1.0")
		value = 1
	sound_level = value
