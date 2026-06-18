class_name Cell
extends Node2D

signal restored
signal destroyed

@export var core_parents: Array[Cell]
@export var core_children: Array[Cell]
@export var repair_rate: float

var is_destroyed := false

var _related_movemenet_collision_shape: CollisionShape2D

@onready var hurtbox_2d: ComponentHurtbox2D = %Hurtbox2D
@onready var health_component: ComponentHealth = %Health
@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var animation_player: AnimationPlayer = %AnimationPlayer


func _ready() -> void:
	hurtbox_2d.got_hit.connect(_on_hit)
	health_component.health_depleted.connect(_on_health_depleted)

func _physics_process(delta: float) -> void:
	if is_destroyed:
		var can_restore := false
		for core_parent: Cell in core_parents:
			if not core_parent.is_destroyed:
				can_restore = true

		if can_restore:
			health_component.current_health += repair_rate * delta
			(sprite_2d.material as ShaderMaterial).set_shader_parameter("hp_ratio", health_component.get_current_health_percentage())

			if health_component.current_health >= health_component.max_health:
				restored.emit()
				_related_movemenet_collision_shape.disabled = false
				hurtbox_2d.monitorable = true
				is_destroyed = false
		elif health_component.current_health > 0:
			health_component.current_health = 0


func get_hurtbox_collision_shape() -> CollisionShape2D:
	return hurtbox_2d.get_collision_shape()

# Shape is used for movement and child of the owner of the ship.
# So cell need to know which collision shape belongs to it to disable it while cell is destroyed.
func set_related_collision_shape(collision_shape: CollisionShape2D) -> void:
	_related_movemenet_collision_shape = collision_shape

func activate_hurtbox_layer(layer: int) -> void:
	hurtbox_2d.set_collision_layer_value(layer, true)


func _on_health_depleted() -> void:
	destroyed.emit()
	_related_movemenet_collision_shape.disabled = true
	modulate.a = 0.5
	hurtbox_2d.monitorable = false
	is_destroyed = true
	(sprite_2d.material as ShaderMaterial).set_shader_parameter("hp_ratio", 0.0)

	for child_cell: Cell in core_children:
		child_cell.health_component.current_health = 0

func _on_hit(hitbox: ComponentHitbox2D) -> void:
	animation_player.play(&"hit")
	health_component.take_damage(hitbox.damage)
