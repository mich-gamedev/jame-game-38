extends Node
@export var health: Health
@export var actor: Node

# Called when the node enters the scene tree for the first time.
func _process(delta: float) -> void:
	if health.health <= 0:
		actor.queue_free()
