class_name Cell
extends Node2D

# TODO. On core destroyed destroye owner too.
@export var is_core := false

@onready var hurtbox_2d: ComponentHurtbox2D = %Hurtbox2D


func get_hurtbox_collision_shape() -> CollisionShape2D:
	return hurtbox_2d.get_collision_shape()

func activate_hurtbox_layer(layer: int) -> void:
	hurtbox_2d.set_collision_layer_value(layer, true)
