extends Area2D
class_name Hurtbox

@export var damage: float = 1
@export var team: Health.Teams
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_damage_hitbox)

func _damage_hitbox(body: Node2D) -> void:
	if body is Hitbox:
		print("damaging")
		body.health.damage(damage)
