extends Area2D
class_name Hitbox

@export var health: Health
@export var team: Health.Teams

# Called when the node enters the scene tree for the first time.
func _ready():
	area_entered.connect(_area_entered)

func _area_entered(area: Area2D)-> void:
	if area is Hurtbox and team == area.team:
		health.damage(area.damage)
