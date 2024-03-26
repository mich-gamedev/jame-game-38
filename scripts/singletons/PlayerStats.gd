extends Node

var player_item: PackedScene
signal player_item_changed
var player_has_wand: bool = false

var levels : Array[String] = [
	"res://levels/1.tscn",
	"res://levels/2.tscn",
]
var level_idx : int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Engine.physics_ticks_per_second = int(DisplayServer.screen_get_refresh_rate())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
