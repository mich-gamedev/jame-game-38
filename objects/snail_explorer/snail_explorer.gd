extends CharacterBody2D

@export var speed: float = 32
@export var gravity: float = 1200

@onready var wall_check: Area2D = $WallCheck
@onready var floor_check: Area2D = $FloorCheck
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer

var flipped = false
var can_flip = false

func _ready():
	can_flip = true

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += gravity * delta
	velocity.x = float(Utilities.get_bool_axis(flipped)) * speed
	move_and_slide()

func _floor_check(_body: Object) -> void:
	if can_flip and is_instance_valid(timer):
		can_flip = false
		timer.start()
		flipped = !flipped
		anim.scale.x = -anim.scale.x
		if floor_check.position.x == -13:
			floor_check.position.x = 14
			wall_check.position.x = 14
			return
		elif floor_check.position.x == 14:
			floor_check.position.x = -13
			wall_check.position.x = -13
			return


func _on_timer_timeout() -> void:
	can_flip = true
