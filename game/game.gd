class_name Game
extends Node

@onready var main_menu: CenterContainer = %MainMenu
@onready var play_button: Button = %PlayButton

const GAME_AREA = preload("uid://b5pqn8r6kxox2")


func _ready() -> void:
	@warning_ignore_start("return_value_discarded")
	play_button.pressed.connect(func():
		main_menu.hide()
		var new_game_area: GameArea = GAME_AREA.instantiate()
		add_child(new_game_area)
	)
