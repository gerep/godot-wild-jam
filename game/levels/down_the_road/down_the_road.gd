extends Node2D

const PACKAGE_SPAWN_INTERVAL = 7.0
const PACKAGES_TO_WIN = 5
const MONEY_PER_PACKAGE = 10

var packages_delivered := 0
var current_money := 0

@onready var package_spawn_timer: Timer = %PackageSpawnTimer


func _ready() -> void:
	package_spawn_timer.start(PACKAGE_SPAWN_INTERVAL)
	package_spawn_timer.timeout.connect(func() -> void:
		# TODO. Need to pick houses which don't have spawned package.
		var random_house: House = get_tree().get_nodes_in_group("houses").pick_random()
		random_house.spawn_package()
		package_spawn_timer.start()
	)

	var turtle: Turtle = get_tree().get_first_node_in_group("turtles")
	turtle.packages_delivered.connect(func(amount: int) -> void:
		packages_delivered += amount
		current_money += amount * MONEY_PER_PACKAGE

		if packages_delivered > PACKAGES_TO_WIN:
			print("You won")
	)
