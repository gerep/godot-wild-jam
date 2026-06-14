class_name BasePlayerTurret
extends Node2D

@onready var shooting_pos: Marker2D = %ShootingPos


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"shoot"):
		var direction := shooting_pos.global_position.direction_to(get_global_mouse_position())
		# HACK. Owner will be ship skeleton. But we need owner of ship skeleton.
		Projectile.create(owner.owner, shooting_pos.global_position, direction, Projectiles.SIMPLE_BULLET)

	if event is InputEventMouseMotion:
		look_at(get_global_mouse_position())
