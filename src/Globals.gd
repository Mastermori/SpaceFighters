extends Node

signal score_changed(new_score)

enum Factions {
	PLAYER,
	ALIENS,
	NEUTRAL,
}

const sounds : Dictionary = {}
const music : Dictionary = {}

var player : KinematicBody2D
var level : Level setget set_level
var level_objects : YSort

var score : int = 0

var sound_level : float setget set_sound_level

onready var window_width : int = ProjectSettings.get("display/window/size/width")
onready var window_height : int = ProjectSettings.get("display/window/size/height")

func _ready():
	add_sound("shoot")
	add_sound("hit")
	add_sound("explosion")
	add_music("relaxing")

func add_points(amount : int):
	score += amount
	emit_signal("score_changed", score)

func add_sound(name : String):
	sounds[name] = get_audio_from_dir("sounds/" + name)

func add_music(name : String):
	music[name] = get_audio_from_dir("music/" + name)

func get_audio_from_dir(name : String, path := "res://assets/") -> Array:
	var dir = Directory.new()
	var sounds_from_dir := []
	path = path + name + "/"
	if dir.open(path) == OK:
		dir.list_dir_begin(true)
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and (file_name.ends_with("wav.import") or file_name.ends_with("ogg.import")):
				sounds_from_dir.append(load(path + file_name.replace(".import", "")))
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

func play_music(name : String , index : int, parent : Node, volume_db = 0.0, pitch_scale = 1.0, is_positional := false, bus = "Music") -> void:
	play_audio(music[name][index], parent, volume_db, pitch_scale, is_positional, bus)

func play_random_music(name : String, parent : Node, volume_db = 0.0, pitch_scale = 1.0, is_positional := false, bus := "Music") -> void:
	play_music(name, randi() % music[name].size(), parent, volume_db, pitch_scale, is_positional, bus)

func play_sound(name : String, index : int, parent : Node, volume_db = 0.0, pitch_scale = 1.0, is_positional := true, bus = "SFX") -> void:
	play_audio(sounds[name][index], parent, volume_db, pitch_scale, is_positional, bus)

func play_random_sound(name : String, parent : Node, volume_db = 0.0, pitch_scale = 1.0, is_positional := true, bus := "SFX") -> void:
	play_sound(name, randi() % sounds[name].size(), parent, volume_db, pitch_scale, is_positional, bus)

func play_audio(audio : AudioStream, parent : Node, volume_db = 0.0, pitch_scale = 1.0, is_positional := false, bus = "Master") -> void:
	var audio_stream_player : Node
	if is_positional:
		audio_stream_player = AudioStreamPlayer2D.new()
	else:
		audio_stream_player = AudioStreamPlayer.new()
	parent.add_child(audio_stream_player)
	audio_stream_player.bus = bus
	audio_stream_player.stream = audio
	audio_stream_player.volume_db = volume_db
	if pitch_scale <= 0:
		pitch_scale = 0.001
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
