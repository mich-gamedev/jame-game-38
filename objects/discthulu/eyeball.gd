extends PathFollow2D

@export var speed: float = 48

func _process(delta: float) -> void:
	progress += speed * delta
