class_name XpOrb
extends CharacterBody2D

static var _xp_orb_ordered_list: Array[XpOrbData]

const _XP_ORB_SCENE = preload("uid://6kn2hv7iovmw")
const _DISTANCE_TO_START_PULLING = 600.0
const _BASE_ATTRACTION_SPEED = 50.0
const _BONUS_ATTRACTION_SPEED = 20000.0
const _SPAWN_OFFSET = 32

var _target: Player
var _xp: int
var _orb_sprite: Texture2D

@onready var _hitbox_2d: ComponentHitbox2D = %Hitbox2D
@onready var _sprite_2d: Sprite2D = %Sprite2D


static func _static_init() -> void:
	_xp_orb_ordered_list.append(XpOrbs.SMALL_XP_ORB)
	_xp_orb_ordered_list.append(XpOrbs.MEDIUM_XP_ORB)
	_xp_orb_ordered_list.append(XpOrbs.BIG_XP_ORB)
	# NOTE. Orbs must apply in descending order, so we spawn bigger xp orbs first.
	_xp_orb_ordered_list.sort_custom(func(orb1: XpOrbData, orb2: XpOrbData) -> bool:
		return orb1.xp_amount > orb2.xp_amount
	)


static func spawn_xp_orbs(spawner: Node2D, xp: int) -> void:
	var remaining_xp := xp

	for xp_orb_data: XpOrbData in _xp_orb_ordered_list:
		@warning_ignore("integer_division")
		var xp_orb_amount: int = remaining_xp / xp_orb_data.xp_amount

		if xp_orb_amount > 0:
			remaining_xp -= xp_orb_amount * xp_orb_data.xp_amount
			for i in xp_orb_amount:
				var xp_orb: XpOrb = xp_orb_data.xp_orb_scene.instantiate()
				xp_orb.setup(xp_orb_data)
				xp_orb.global_position = spawner.global_position + VectorUtils.get_random_vector2(_SPAWN_OFFSET)
				spawner.get_tree().root.add_child(xp_orb)

	assert(remaining_xp == 0, "Couldn't transform all exp to orbs. Remaining XP: %s" % remaining_xp)


func _ready() -> void:
	_hitbox_2d.hit.connect(_on_hit)

	# NOTE. Perhaps add animation later or remove it.
	#var min_angle = -10.0
	#var max_angle = 10.0
	#var rotation_time = 0.85
#
	#var initial_angle := randf_range(min_angle, max_angle)
	#_sprite_2d.rotation_degrees = initial_angle
#
	#var tween := create_tween()
	#tween.tween_property(_sprite_2d, "rotation_degrees", max_angle, rotation_time).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	#tween.tween_property(_sprite_2d, "rotation_degrees", initial_angle, rotation_time).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	#tween.set_loops()


func _physics_process(delta: float) -> void:
	if _target == null:
		_target = get_tree().get_first_node_in_group(Groups.PLAYERS)

	if _target != null:
		var distance_to_target := global_position.distance_to(_target.global_position)
		if distance_to_target <= _DISTANCE_TO_START_PULLING:
			var speed := _BASE_ATTRACTION_SPEED + _BONUS_ATTRACTION_SPEED / distance_to_target
			velocity = global_position.direction_to(_target.global_position) * speed
			move_and_slide()


func setup(xp_orb_data: XpOrbData) -> void:
	_xp = xp_orb_data.xp_amount

func get_xp() -> int:
	return _xp


func _on_hit(hurtbox: ComponentHurtbox2D) -> void:
	queue_free()
