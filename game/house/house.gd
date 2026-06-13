class_name House
extends StaticBody2D

const PACKAGE = preload("uid://cnpq1fg02xlck")

@onready var package_spawn_point_2d: Marker2D = %PackageSpawnPoint2D


func spawn_package() -> void:
	var new_package: Package = PACKAGE.instantiate()
	new_package.position = package_spawn_point_2d.position
	add_child(new_package)
