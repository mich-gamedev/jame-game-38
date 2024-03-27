extends Node
class_name Health

enum Teams {Player, Enemy}


@export var max_health: float
@export var starting_health:float
@onready var health: float = starting_health

signal damaged(amount)

func damage(amount: float) -> float:
	print("%s took damage" % owner.name)
	damaged.emit(amount)
	health -= amount
	health = clamp(health, 0, max_health)
	return health
