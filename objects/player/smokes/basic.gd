extends CharacterBody2D

@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var area_2d: Area2D = $Area2D
func _physics_process(delta):
	var coll_info = move_and_collide(velocity * delta)
	if coll_info:
		if is_instance_valid(area_2d):
			area_2d.queue_free()
		gpu_particles_2d.emitting = false
		delete_character()

func delete_character():
	await get_tree().create_timer(1).timeout
	print("deleting")
	queue_free()

