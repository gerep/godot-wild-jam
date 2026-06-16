extends Node2D

@onready var start_trigger_area_2d: Area2D = $StartTriggerArea2D
@onready var end_trigger_area_2d: Area2D = $EndTriggerArea2D
@onready var start_exit_marker_2d: Marker2D = $StartExitMarker2D
@onready var end_exit_marker_2d_2: Marker2D = $EndExitMarker2D2


func _ready() -> void:
	start_trigger_area_2d.area_entered.connect(_on_start_trigger_area_entered)
	end_trigger_area_2d.area_entered.connect(_on_end_trigger_area_entered)


func _on_start_trigger_area_entered(area: Area2D) -> void:
	var player: Player = get_tree().get_first_node_in_group(Groups.PLAYERS) as Player
	if player == null or player.is_auto_moving:
		return

	player.auto_move_to(end_exit_marker_2d_2.global_position)


func _on_end_trigger_area_entered(area: Area2D) -> void:
	var player: Player = get_tree().get_first_node_in_group(Groups.PLAYERS) as Player
	if player == null or player.is_auto_moving:
		return

	player.auto_move_to(start_exit_marker_2d.global_position)
