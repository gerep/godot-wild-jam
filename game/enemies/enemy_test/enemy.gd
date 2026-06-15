class_name Enemy
extends CharacterBody2D

@export var xp: int
@export var move_speed := 120.0
@export var direction_change_interval := 1.5
@export var shoot_cooldown := 1.0

var _move_direction := Vector2.RIGHT
var _direction_change_timer := 0.0
var _shoot_timer := 0.0

@onready var basic_enemy_ship: ShipSkeleton = %BasicEnemyShip


func _ready() -> void:
	basic_enemy_ship.destroyed.connect(_on_ship_destroyed)
	_pick_random_move_direction()
	_direction_change_timer = randf_range(0.0, direction_change_interval)
	_shoot_timer = randf_range(0.0, shoot_cooldown)


func _physics_process(delta: float) -> void:
	_update_movement(delta)
	_update_shooting(delta)


func _update_movement(delta: float) -> void:
	_direction_change_timer -= delta
	if _direction_change_timer <= 0.0:
		_pick_random_move_direction()

	velocity = _move_direction * move_speed
	move_and_slide()

	if get_slide_collision_count() > 0:
		_move_direction = -_move_direction
		_direction_change_timer = direction_change_interval


func _update_shooting(delta: float) -> void:
	var player := get_tree().get_first_node_in_group(Groups.PLAYERS) as Player
	if player == null:
		return
	if player.current_area != get_parent():
		return

	_shoot_timer -= delta
	if _shoot_timer > 0.0:
		return

	_shoot_timer = shoot_cooldown

	var direction := global_position.direction_to(player.global_position)
	Projectile.create(self, global_position, direction, Projectiles.SIMPLE_BULLET)


func _pick_random_move_direction() -> void:
	_move_direction = Vector2.RIGHT.rotated(randf_range(0.0, TAU))
	_direction_change_timer = direction_change_interval


func _on_ship_destroyed() -> void:
	XpOrb.spawn_xp_orbs(self, xp)
	queue_free()
