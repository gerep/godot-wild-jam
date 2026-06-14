class_name VectorUtils
extends Node

static func get_random_vector2(offset: float) -> Vector2:
	return Vector2(randf_range(-offset, offset), randf_range(-offset, offset))
