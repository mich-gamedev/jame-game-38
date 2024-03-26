extends CharacterBody2D

@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _physics_process(delta):
	var coll_info = move_and_collide(velocity * delta)
	if coll_info:
		if is_instance_valid(area_2d):
			area_2d.queue_free()
		gpu_particles_2d.one_shot = true
		delete_character()

func delete_character():
	collision_shape_2d.queue_free()
	await gpu_particles_2d.finished
	print("deleting")
	queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Hitbox and area.team == area_2d.team:
		gpu_particles_2d.emitting = false
		await delete_character()
		area_2d.queue_free()
