extends MarginContainer

export(NodePath) var health_tracking

onready var score := $HBoxContainer/Scores/HBoxContainer/Score

func _ready():
	var tracking = get_node(health_tracking)
	var health_bar := $HBoxContainer/Bars/MarginContainer/HealthBar
	tracking.connect("health_changed", health_bar, "_on_Character_health_changed")
	Globals.connect("score_changed", self, "update_score")

func update_score(amount : int):
	score.text = str(amount)
