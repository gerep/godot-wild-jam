class_name Enemy
extends CharacterBody2D

@export var xp: int

@onready var basic_enemy_ship: ShipSkeleton = %BasicEnemyShip


func _ready() -> void:
	basic_enemy_ship.destroyed.connect(_on_ship_destroyed)


func _on_ship_destroyed() -> void:
	XpOrb.spawn_xp_orbs(self, xp)
	queue_free()
