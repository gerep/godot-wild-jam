class_name ComponentHurtbox2D
extends Area2D

# Called in hitbox
@warning_ignore_start("unused_signal")
signal got_hit(hitbox: ComponentHitbox2D)
@warning_ignore_restore("unused_signal")
