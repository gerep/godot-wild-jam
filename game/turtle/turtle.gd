class_name Turtle
extends CharacterBody2D

signal package_picked(current_amount: int)
signal packages_delivered(amount: int)

const SPEED = 300.0
const MAX_PACKAGES = 4

var current_packages := 0

@onready var package_picker_2d: Area2D = %PackagePicker2D
@onready var dropoff_finder_2d: Area2D = %DropoffFinder2D


func _ready() -> void:
	package_picker_2d.area_entered.connect(func(package: Package) -> void:
		if current_packages < MAX_PACKAGES:
			package.pick_up()
			current_packages += 1
			package_picked.emit(current_packages)
	)
	dropoff_finder_2d.area_entered.connect(func(dropoff: Node2D) -> void:
		if current_packages > 0:
			packages_delivered.emit(current_packages)
			current_packages = 0
	)

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")
	velocity = direction * SPEED

	# Look a the direction of movement.
	if velocity:
		rotation = velocity.angle() - PI / 2

	move_and_slide()
