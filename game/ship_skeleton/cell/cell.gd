class_name Cell
extends Node2D

signal destroyed

# TODO. On core destroyed destroye owner too.
@export var is_core := false
@export var health: float

@onready var hurtbox_2d: ComponentHurtbox2D = %Hurtbox2D
@onready var health_component: ComponentHealth = %Health


func _ready() -> void:
	hurtbox_2d.got_hit.connect(_on_hit)
	health_component.health_depleted.connect(_on_health_depleted)

	health_component.set_health(health)


func get_hurtbox_collision_shape() -> CollisionShape2D:
	return hurtbox_2d.get_collision_shape()

func activate_hurtbox_layer(layer: int) -> void:
	hurtbox_2d.set_collision_layer_value(layer, true)


func _on_health_depleted() -> void:
	destroyed.emit()
	queue_free()

func _on_hit(hitbox: ComponentHitbox2D) -> void:
	health_component.take_damage(hitbox.damage)
