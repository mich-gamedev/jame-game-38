extends CharacterBody2D

var player_in_range: bool = false
var was_on_floor: bool = false
@export var speed: float = 72
@export var gravity: float = 1200

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += gravity * delta

	if player_in_range:
		velocity.x = speed * anim.scale.x
		anim.play(&"run")
	else: 
		anim.play(&"idle")
		velocity.x = 0

	if is_on_wall() and !was_on_floor:
		was_on_floor = true
		anim.scale.x = -anim.scale.x
	if !is_on_wall():
		was_on_floor = false

	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if !player_in_range and body.is_in_group(&"player"):
		player_in_range = true
		if body.global_position.x > global_position.x:
			anim.scale.x = 1
		else:
			anim.scale.x = -1


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group(&"player"):
		player_in_range = false
