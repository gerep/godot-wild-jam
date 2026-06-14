extends Node2D

@onready var shooting_pos: Marker2D = $ShootingPos


func _ready() -> void:
	pass # Replace with function body.

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"shoot"):
		var direction := shooting_pos.global_position.direction_to(get_global_mouse_position())
		Projectile.create(owner, shooting_pos.global_position, direction, Projectiles.SIMPLE_BULLET)

	if event is InputEventMouseMotion:
		look_at(get_global_mouse_position())
