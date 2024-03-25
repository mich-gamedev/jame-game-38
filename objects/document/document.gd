extends Droppable

@export var gravity: float = 800.0

func _physics_process(delta: float) -> void:
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0, 1000 * delta)
		set_collision_layer_value(1, true)
		set_collision_mask_value(1, true)
	else:
		velocity.y += gravity * delta
	move_and_slide()

func drop():
	super()
	velocity = to_local(get_global_mouse_position()) * 2.0
	collision_layer = 4
	collision_mask = 4
