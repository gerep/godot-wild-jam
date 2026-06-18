class_name ComponentHealth
extends Node

signal max_health_changed(new_value: float)
signal current_health_changed(new_value: float)
signal health_depleted()

@export var max_health := 100.0:
	set(value):
		max_health = value
		max_health_changed.emit(value)

@export var health_regeneration_rate := 0.0

var current_health := 1.0:
	set(value):
		print("%s new health is %s." % [owner.name, value])
		current_health = clampf(value, 0, max_health)
		current_health_changed.emit(current_health)
		if is_zero_approx(current_health):
			print("%s health depleted." % owner.name)
			health_depleted.emit()



func _ready() -> void:
	# Since current health won't consider value from @export.
	current_health = max_health

func _physics_process(delta: float) -> void:
	if not is_zero_approx(health_regeneration_rate) \
		and not is_equal_approx(current_health, max_health):

		current_health += health_regeneration_rate * delta


func get_current_health_percentage() -> float:
	return current_health / max_health


func set_health(health: float) -> void:
	print("set_health called with: ", health)
	max_health = health
	current_health = health


func take_damage(damage: float) -> void:
	current_health -= damage
