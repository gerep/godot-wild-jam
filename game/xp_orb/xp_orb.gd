class_name XpOrb
extends Node2D

static var _xp_orb_ordered_list: Array[XpOrbData]

const _XP_ORB_SCENE = preload("uid://6kn2hv7iovmw")
const _BASE_ATTRACTION_SPEED = 500.0
const _BASE_ATTRACTION_DISTANCE_INTERVAL = 15.0
const _ATTRACTION_MULT = 1.3
const _SPAWN_OFFSET = 5

var _target: Player
var _xp: int
var _orb_sprite: Texture2D

@onready var _sprite_2d: Sprite2D = %Sprite2D
@onready var _hitbox_2d: ComponentHitbox2D = %Hitbox2D
@onready var _visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = %VisibleOnScreenNotifier2D


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
				var xp_orb: XpOrb = _XP_ORB_SCENE.instantiate()
				xp_orb.setup(xp_orb_data)
				xp_orb.global_position = spawner.global_position + VectorUtils.get_random_vector2(_SPAWN_OFFSET)
				spawner.get_tree().root.add_child(xp_orb)

	assert(remaining_xp == 0, "Couldn't transform all exp to orbs. Remaining XP: %s" % remaining_xp)


func _ready() -> void:
	_hitbox_2d.hit.connect(_on_hit)
	_visible_on_screen_notifier_2d.screen_exited.connect(_on_screen_exited)

	_sprite_2d.texture = _orb_sprite

func _physics_process(delta: float) -> void:
	if _target == null:
		_target = get_tree().get_first_node_in_group(Groups.PLAYERS)

	if _target != null:
		var distance_to_target := global_position.distance_to(_target.global_position)
		var speed := _BASE_ATTRACTION_SPEED / pow(_ATTRACTION_MULT, distance_to_target / _BASE_ATTRACTION_DISTANCE_INTERVAL)
		global_position = global_position.move_toward(_target.global_position, speed * delta)


func setup(xp_orb_data: XpOrbData) -> void:
	_xp = xp_orb_data.xp_amount
	_orb_sprite = xp_orb_data.orb_sprite

func get_xp() -> int:
	return _xp


func _on_hit(hurtbox: ComponentHurtbox2D) -> void:
	queue_free()

func _on_screen_exited() -> void:
	queue_free()
