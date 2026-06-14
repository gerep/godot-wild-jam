@tool
class_name ShipSkeleton
extends Node2D

signal destroyed

const CELL_CONNECTOR = preload("uid://cdeg2ih3g8ys4")

@export_tool_button("Calculate core connections")

var calculate_core_connections_action: Callable = calculate_core_connections

@onready var cell_connectors: Node2D = %CellConnectors


func _ready() -> void:
	if Engine.is_editor_hint():
		return

	for child in get_children():
		if not child is Cell:
			continue
		var cell = child as Cell

		# Gives parent collision shapes of all cells. Since the movement logic is located in owner node.
		var hurtbox_shape := cell.get_hurtbox_collision_shape()
		var collision_shape := hurtbox_shape.duplicate()
		collision_shape.position = to_local(hurtbox_shape.global_position)
		add_sibling.call_deferred(collision_shape)

		cell.set_related_collision_shape(collision_shape)

		# Activate proper hurtbox layer, since cell can be owned by player or enemy.
		if owner is Player:
			cell.activate_hurtbox_layer(CollisionLayers.PLAYER_HURTBOX)
		else:
			cell.activate_hurtbox_layer(CollisionLayers.ENEMY_HURTBOX)

		if cell.is_core:
			cell.destroyed.connect(func():
				destroyed.emit()
			)


# TOOL. Connects cells between each other depending on position relative to the core.
func calculate_core_connections():
	for child in cell_connectors.get_children():
		child.queue_free()

	var core: Cell

	for cell: Cell in get_children():
		if cell.is_core:
			core = cell
			break

	fill_core_connections(core)

func fill_core_connections(cell: Cell) -> void:
	var shape = cell.get_node("Hurtbox2D/CollisionShape2D").shape.duplicate()
	var distance_check_mult := 1.25

	# CRITICAL. Assuming we only use capsule shapes for cells
	assert(shape is CapsuleShape2D, "Core is not found")

	shape = shape as CapsuleShape2D

	shape.height *= distance_check_mult
	shape.radius *= distance_check_mult

	var dss := get_world_2d().direct_space_state
	var query: PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
	query.collide_with_areas = true
	query.collision_mask = pow(2, CollisionLayers.CORE_CONNECTION_CHECKER - 1)
	query.shape = shape
	query.transform = cell.get_transform()
	query.exclude = [cell.get_node("Hurtbox2D").get_rid()]

	var results = dss.intersect_shape(query)
	for result in results:
		var colliding_cell: Cell = result.collider.owner
		if cell.core_parents.has(colliding_cell):
			continue

		var cell_connector: Line2D = CELL_CONNECTOR.instantiate()
		var my_array: Array
		my_array.append(cell.position)
		my_array.append(colliding_cell.position)
		cell_connector.points = my_array

		cell_connectors.add_child(cell_connector)
		cell_connector.owner = self

		colliding_cell.core_parents.clear()
		colliding_cell.core_parents.append(cell)

		fill_core_connections(colliding_cell)
