class_name Enemy
extends CharacterBody2D

@export var health: float
@export var xp: int

@onready var _hurtbox_2d: ComponentHurtbox2D = %Hurtbox2D
@onready var _health_component: ComponentHealth = %Health

# TODO
#
#func _ready() -> void:
	#_hurtbox_2d.got_hit.connect(_on_hit)
	#_health_component.health_depleted.connect(_on_health_depleted)
#
	#_health_component.set_health(health)
#
#
#func _on_health_depleted() -> void:
	#XpOrb.spawn_xp_orbs(self, xp)
	#queue_free()
#
#func _on_hit(hitbox: ComponentHitbox2D) -> void:
	#_health_component.take_damage(hitbox.damage)
