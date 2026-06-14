class_name ShipSkeleton
extends Node2D

signal destroyed

func _ready() -> void:
	for cell: Cell in get_children():
		# Gives parent collision shapes of all cells. Since the movement logic is located in owner node.
		var hurtbox_shape := cell.get_hurtbox_collision_shape()
		var collision_shape := hurtbox_shape.duplicate()
		collision_shape.position = to_local(hurtbox_shape.global_position)
		add_sibling.call_deferred(collision_shape)

		# Activate proper hurtbox layer, since cell can be owned by player or enemy.
		if owner is Player:
			cell.activate_hurtbox_layer(CollisionLayers.PLAYER_HURTBOX)
		else:
			cell.activate_hurtbox_layer(CollisionLayers.ENEMY_HURTBOX)

		if cell.is_core:
			cell.destroyed.connect(func():
				destroyed.emit()
			)
