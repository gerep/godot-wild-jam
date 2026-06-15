class_name Projectile
extends Node2D

var _damage: float
var _speed: float
var _direction: Vector2

@onready var hitbox_2d: ComponentHitbox2D = %Hitbox2D


static func create(shooter: Node2D, pos: Vector2, direction: Vector2, projectile_data: ProjectileData) -> void:
	var projectile := projectile_data.projectile.instantiate() as Projectile
	projectile.setup(projectile_data, direction)
	projectile.global_position = pos
	shooter.get_tree().root.add_child(projectile)
	projectile.hitbox_2d.set_collision_mask_value(CollisionLayers.WORLD, true)

	if shooter is Player:
		projectile.hitbox_2d.set_collision_mask_value(CollisionLayers.ENEMY_HURTBOX, true)
	else: # Enemy is shooting
		projectile.hitbox_2d.set_collision_mask_value(CollisionLayers.PLAYER_HURTBOX, true)


func setup(projectile_data: ProjectileData, direction: Vector2) -> void:
	_damage = projectile_data.damage
	_speed = projectile_data.speed
	_direction = direction
