extends Droppable

# Called when the node enters the scene tree for the first time.
func _drop():
	velocity = to_local(get_global_mouse_position())
