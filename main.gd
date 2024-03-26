extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var new_level = load(PlayerStats.levels[PlayerStats.level_idx]).instantiate()
	add_child(new_level)
