class_name ComponentHitbox2D
extends Area2D

signal hit(hurtbox: ComponentHurtbox2D)

@export var damage := 5.0


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _notify_about_collision(hurtbox: ComponentHurtbox2D) -> void:
	hit.emit(hurtbox)
	hurtbox.got_hit.emit(self)


func _on_area_entered(hurtbox: ComponentHurtbox2D) -> void:
	_notify_about_collision.call_deferred(hurtbox)
