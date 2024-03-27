extends Node
class_name Hitflash

@export var health: Health
@export var actor: CanvasItem

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health.damaged.connect(_harmed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _harmed(_amount: float) -> void:
	actor.material.set_shader_parameter("enabled", true)
	await get_tree().create_timer(0.1).timeout
	actor.material.set_shader_parameter("enabled", false)
