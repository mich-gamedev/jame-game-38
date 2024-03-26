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
@onready var wand: Sprite2D = $AnimatedSprite2D/Wand

var jumping: bool = false
var can_jump: bool = false
var can_fire: bool = true

func _ready():
	PlayerStats.player_item = null
	wand.visible = PlayerStats.player_has_wand

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
		new_item.global_position = global_position
		new_item.drop()
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("action_1") and PlayerStats.player_has_wand and !PlayerStats.player_item and can_fire:
		can_fire = false
		var bullet: CharacterBody2D = preload("res://objects/player/smokes/basic.tscn").instantiate() as CharacterBody2D
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = wand.global_position
		bullet.velocity = wand.global_position.direction_to(get_global_mouse_position()) * 96
		await get_tree().create_timer(0.3).timeout
		can_fire = true

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


func _on_area_2d_body_entered(body):
	get_tree().reload_current_scene.call_deferred()
