extends CharacterBody2D

#todo - add controller support
@export var speed: float = 120
@export var accel: float = 1500
@export var air_accel: float = 800
@export var friction: float = 720
@export var air_friction: float = 720
@export var jump_speed: float = 160
@export var gravity: float = 2000

@onready var coyote_timer: Timer = $CoyoteTimer
@onready var buffer_timer: Timer = $BufferTimer
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var particle: GPUParticles2D = $GPUParticles2D

var jumping: bool = false
var can_jump: bool = true

func _physics_process(delta: float) -> void:

	#region x axis input
	var input_axis = Input.get_axis("move_left", "move_right")
	if input_axis:
		if is_on_floor():
			if !is_on_wall():
				particle.emitting = true
				anim.play(&"walk")
			velocity.x = move_toward(velocity.x, input_axis * speed, accel * delta)
			flip_tween(input_axis, 0.2)
		else:
			velocity.x = move_toward(velocity.x, input_axis * speed, air_accel * delta)
			flip_tween(input_axis, 0.5)
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0.0, friction * delta)
		else:
			velocity.x = move_toward(velocity.x, 0.0, air_friction * delta)
	#endregion

	#region jumping
	if is_on_floor():
		if !input_axis or is_on_wall():
			anim.play(&"idle")
			particle.emitting = false
		can_jump = true
		coyote_timer.start() 
	else:
		velocity.y += gravity * delta
		particle.emitting = false
	if Input.is_action_just_pressed("jump"):
		jumping = true
		buffer_timer.start()

	if can_jump and jumping:
		jumping = false
		velocity.y = -jump_speed
		anim.play(&"jump")
	#endregion

	#region throwing
	if PlayerStats.player_item and Input.is_action_just_pressed("action_1"):
		var new_item = PlayerStats.player_item.instantiate()
		get_tree().current_scene.add_child(new_item)
		new_item.global_position = global_position + (Vector2.UP * 12)
		new_item.drop()
	move_and_slide()

func flip_tween(flip_to: int, time_sec: float) -> void:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(anim, "scale:x", flip_to, time_sec)

func _buffer_timeout() -> void: # connected to $BufferTimer.timeout
	jumping = false

func _coyote_timeout() -> void: # connected to $CoyoteTimer.timeout
	can_jump = false


func _animation_finished() -> void: # connected to $AnimatedSprite2D.animation_finished
	if anim.animation == &"jump":
		anim.play(&"fall_start")
		return
	if anim.animation == &"fall_start":
		anim.play(&"fall")
