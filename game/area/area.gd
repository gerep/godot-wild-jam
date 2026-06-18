class_name ArenaArea
extends Node2D

@onready var player_detector: Area2D = $PlayerDetector

@onready var west_creation_area: Area2D = $AreaCreation/WestCreationArea
@onready var west_transport_area: Area2D = $Transport/WestTransportArea
@onready var west_marker: Marker2D = $Markers/WestMarker

@onready var east_creation_area: Area2D = $AreaCreation/EastCreationArea
@onready var east_transport_area: Area2D = $Transport/EastTransportArea
@onready var east_marker: Marker2D = $Markers/EastMarker

@onready var north_creation_area: Area2D = $AreaCreation/NorthCreationArea
@onready var north_transport_area: Area2D = $Transport/NorthTransportArea
@onready var north_marker: Marker2D = $Markers/NorthMarker

@onready var south_creation_area: Area2D = $AreaCreation/SouthCreationArea
@onready var south_transport_area: Area2D = $Transport/SouthTransportArea
@onready var south_marker: Marker2D = $Markers/SouthMarker

signal new_area_requested(area: ArenaArea, side: StringName)
signal transport_requested(area: ArenaArea, side: StringName)

var grid_position := Vector2i.ZERO


func _ready() -> void:
	west_creation_area.body_entered.connect(_on_creation_area_body_entered.bind(&"west", west_creation_area))
	west_transport_area.body_entered.connect(_on_transport_area_body_entered.bind(&"west"))

	east_creation_area.body_entered.connect(_on_creation_area_body_entered.bind(&"east", east_creation_area))
	east_transport_area.body_entered.connect(_on_transport_area_body_entered.bind(&"east"))

	north_creation_area.body_entered.connect(_on_creation_area_body_entered.bind(&"north", north_creation_area))
	north_transport_area.body_entered.connect(_on_transport_area_body_entered.bind(&"north"))

	south_creation_area.body_entered.connect(_on_creation_area_body_entered.bind(&"south", south_creation_area))
	south_transport_area.body_entered.connect(_on_transport_area_body_entered.bind(&"south"))


func _on_transport_area_body_entered(_body: Node2D, side: StringName) -> void:
	transport_requested.emit(self, side)


func get_marker_for_side(side: StringName) -> Vector2:
	match side:
		&"north":
			return north_marker.global_position
		&"south":
			return south_marker.global_position
		&"east":
			return east_marker.global_position
		&"west":
			return west_marker.global_position

	return Vector2.ZERO


# Once created, we don't need to monitor the area anymore.
func _on_creation_area_body_entered(_body: Node2D, side: StringName, area: Area2D) -> void:
	area.set_deferred(&"monitoring", false)
	new_area_requested.emit(self, side)


# When this area is created beside another one, disable the creation trigger that points back to the
# already-existing neighbor.
func disable_area_creation_on_side(side: StringName) -> void:
	match side:
		&"north":
			south_creation_area.set_deferred(&"monitoring", false)
		&"south":
			north_creation_area.set_deferred(&"monitoring", false)
		&"east":
			west_creation_area.set_deferred(&"monitoring", false)
		&"west":
			east_creation_area.set_deferred(&"monitoring", false)
