class_name ComponentHurtbox2D
extends Area2D

@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D

# Called in hitbox
@warning_ignore_start("unused_signal")
signal got_hit(hitbox: ComponentHitbox2D)
@warning_ignore_restore("unused_signal")


func get_collision_shape() -> CollisionShape2D:
	return collision_shape_2d
