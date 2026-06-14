class_name Player
extends CharacterBody2D

const SPEED = 300.0

@onready var _hurtbox_2d: ComponentHurtbox2D = %Hurtbox2D
@onready var _experience: ComponentExperience = %Experience


func _ready() -> void:
	_hurtbox_2d.got_hit.connect(_on_got_hit)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"shoot"):
		var direction := global_position.direction_to(get_global_mouse_position())
		Projectile.create(self, global_position, direction, Projectiles.SIMPLE_BULLET)

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")
	velocity = direction * SPEED

	move_and_slide()


func _on_got_hit(hitbox: ComponentHitbox2D) -> void:
	if hitbox.owner is XpOrb:
		var xp_orb := hitbox.owner as XpOrb
		_experience.add_xp(xp_orb.get_xp())
