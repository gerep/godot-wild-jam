class_name GameArea
extends Node2D

const ROOM_SPACING = 3250
const AREA = preload("uid://b8s7r2s04sqw3")

@onready var area: ArenaArea = $Area
@onready var player: Player = $Player

var areas: Dictionary[Vector2i, ArenaArea] = {}


func _ready() -> void:
	player.current_area = area
	_register_area(area)


func _on_area_transport_requested(source_area: ArenaArea, side: StringName) -> void:
	if player.is_auto_moving:
		return

	var target_grid_position := source_area.grid_position + _get_direction(side)
	var target_area: ArenaArea = areas.get(target_grid_position)

	if target_area == null:
		return

	var marker := target_area.get_marker_for_side(_get_opposite_side(side))
	player.current_area = target_area
	player.auto_move_to(marker)


func _get_opposite_side(side: StringName) -> StringName:
	match side:
		&"west":
			return &"east"
		&"east":
			return &"west"
		&"north":
			return &"south"
		&"south":
			return &"north"

	return &""


func _deferred_new_area(source_area: ArenaArea, side: StringName) -> void:
	_on_new_area_requested.call_deferred(source_area, side)


func _register_area(area_to_register: ArenaArea) -> void:
	areas[area_to_register.grid_position] = area_to_register
	area_to_register.transport_requested.connect(_on_area_transport_requested)
	area_to_register.new_area_requested.connect(_deferred_new_area)


func _on_new_area_requested(source_area: ArenaArea, side: StringName) -> void:
	var target_grid_position := source_area.grid_position + _get_direction(side)
	if areas.has(target_grid_position):
		return

	var new_area: ArenaArea = AREA.instantiate()
	new_area.grid_position = target_grid_position
	new_area.position = Vector2(target_grid_position) * ROOM_SPACING

	add_child(new_area)

	new_area.disable_area_creation_on_side(side)
	_register_area(new_area)


func _get_direction(side: StringName) -> Vector2i:
	match side:
		&"north":
			return Vector2i.UP
		&"south":
			return Vector2i.DOWN
		&"east":
			return Vector2i.RIGHT
		&"west":
			return Vector2i.LEFT

	return Vector2i.ZERO
