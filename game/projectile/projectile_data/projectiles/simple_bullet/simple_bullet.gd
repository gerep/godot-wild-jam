class_name SimpleBullet
extends Projectile

@onready var _hitbox_2d: ComponentHitbox2D = %Hitbox2D


func _ready() -> void:
	_hitbox_2d.hit.connect(_on_hit)
	_hitbox_2d.damage = _damage

func _physics_process(delta: float) -> void:
	global_position += _direction * _speed * delta


func _on_hit(hurtbox: ComponentHurtbox2D) -> void:
	queue_free()
