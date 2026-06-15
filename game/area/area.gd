class_name ArenaArea
extends Node2D

@onready var player_detector: Area2D = $PlayerDetector

func _ready() -> void:
	player_detector.body_entered.connect(_on_player_detector_body_entered)


func _on_player_detector_body_entered(body: Node2D) -> void:
	var player := body as Player
	if player == null:
		return

	player.current_area = self
