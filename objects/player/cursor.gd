extends Sprite2D

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group(&"player")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()
	rotation = global_position.angle_to_point(player.global_position)
