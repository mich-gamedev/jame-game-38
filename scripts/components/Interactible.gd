extends Area2D
class_name Interactible

var player_in_area: bool = false
@export var sprite: Node2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_body_entered)
	body_exited.connect(_body_exited)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _body_entered(body: Object) -> void:
	if body.is_in_group(&"player"):
		player_in_area = true
		sprite.visible = true
func _body_exited(body:Object) -> void:
	if body.is_in_group(&"player"):
		player_in_area = false
		sprite.visible = false


func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if (!PlayerStats.player_item) and player_in_area and event.is_action_pressed("action_1"):
		var new_item = PackedScene.new()
		new_item.pack(owner)
		await get_tree().create_timer(0.05).timeout
		PlayerStats.player_item = new_item
		PlayerStats.player_item_changed.emit()
		owner.queue_free()
		print("player grabbed %s" % owner.name) #todo - remove name
