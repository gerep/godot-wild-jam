class_name Player
extends CharacterBody2D

const SPEED = 300.0

const TRANSPORTING_SPEED = 1000.0
const AUTO_MOVE_STOP_DISTANCE = 4.0

var is_auto_moving: bool = false
var auto_move_target: Vector2

@onready var _hurtbox_2d: ComponentHurtbox2D = %Hurtbox2D
@onready var _experience: ComponentExperience = %Experience


func _ready() -> void:
	_hurtbox_2d.got_hit.connect(_on_got_hit)


func _unhandled_input(event: InputEvent) -> void:
	if is_auto_moving:
		return


func _physics_process(delta: float) -> void:
	if is_auto_moving:
		var distance_to_target := global_position.distance_to(auto_move_target)
		# This is a way to avoid the player from overshoothing the `auto_move_target` when the
		# transport speed is too high.
		var max_travel_distance := TRANSPORTING_SPEED * delta

		if distance_to_target <= max(AUTO_MOVE_STOP_DISTANCE, max_travel_distance):
			global_position = auto_move_target
			velocity = Vector2.ZERO
			is_auto_moving = false
		else:
			var auto_move_direction := global_position.direction_to(auto_move_target)
			velocity = auto_move_direction * TRANSPORTING_SPEED
			move_and_slide()

		return

	var direction := Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")
	velocity = direction * SPEED

	move_and_slide()


func _on_got_hit(hitbox: ComponentHitbox2D) -> void:
	if hitbox.owner is XpOrb:
		var xp_orb := hitbox.owner as XpOrb
		_experience.add_xp(xp_orb.get_xp())


func auto_move_to(pos: Vector2) -> void:
	is_auto_moving = true
	auto_move_target = pos
	velocity = Vector2.ZERO
