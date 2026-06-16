class_name BasePlayerTurret
extends Node2D

@onready var shooting_pos: Marker2D = %ShootingPos


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"shoot"):
		# NOTE. For player will shot straight for now. For AI perhaps could rotate turrets.
		#var direction := shooting_pos.global_position.direction_to(get_global_mouse_position())
		var direction := Vector2.RIGHT.rotated(global_rotation)
		# HACK. Owner will be ship skeleton. But we need owner of ship skeleton.
		Projectile.create(owner.owner, shooting_pos.global_position, direction, Projectiles.SIMPLE_BULLET)

	# NOTE. Disable turrent rotation for now.
	#if event is InputEventMouseMotion:
		#look_at(get_global_mouse_position())
