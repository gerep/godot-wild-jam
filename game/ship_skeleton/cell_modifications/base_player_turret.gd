class_name BasePlayerTurret
extends Node2D

@export var _attack_cooldown := 1.0

var _can_shoot := true

@onready var shooting_pos: Marker2D = %ShootingPos
@onready var attack_cooldown_timer: Timer = %AttackCooldownTimer


func _ready() -> void:
	attack_cooldown_timer.timeout.connect(func():
		_can_shoot = true
	)

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed(&"shoot") and _can_shoot:
		_can_shoot = false
		attack_cooldown_timer.start(_attack_cooldown)
		# NOTE. For player will shot straight for now. For AI perhaps could rotate turrets.
		#var direction := shooting_pos.global_position.direction_to(get_global_mouse_position())
		var direction := Vector2.RIGHT.rotated(global_rotation)
		# HACK. Owner will be ship skeleton. But we need owner of ship skeleton.
		Projectile.create(owner.owner, shooting_pos.global_position, direction, Projectiles.SIMPLE_BULLET)
		AudioSystem.play_sfx(Sounds.BUBBLE_POP)
	# NOTE. Disable turrent rotation for now.
	#if event is InputEventMouseMotion:
		#look_at(get_global_mouse_position())
