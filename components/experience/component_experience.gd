class_name ComponentExperience
extends Node

signal lvl_up(lvl: int)
signal max_lvl_reached()

@export var _max_level := 10
@export var _current_level := 1
@export var _base_xp := 100
@export var _flat_xp_increase: int = 0
@export var _mult_xp_increase: float = 1.0

var _current_xp := 0
var _xp_per_lvl: Dictionary[int, int]


func _ready() -> void:
	for i in range(_current_level, _max_level):
		if i == 1:
			_xp_per_lvl[i] = _base_xp
		else:
			_xp_per_lvl[i] = round(_xp_per_lvl[i - 1] * _mult_xp_increase) + _flat_xp_increase * (i - 1)


func add_xp(xp: int) -> void:
	if _current_level == _max_level:
		return

	_current_xp += xp
	if _current_xp >= _xp_per_lvl[_current_level]:
		_current_xp -= _xp_per_lvl[_current_level]
		_current_level += 1
		print("%s reached lvl %s." % [str(owner.name), _current_level])
		lvl_up.emit(_current_level)
		if _current_level == _max_level:
			print("%s reached max lvl." % str(owner.name))
			max_lvl_reached.emit()
		else:
			# NOTE. Check if got exp enough to lvl up 2 and more times.
			if _current_xp > _xp_per_lvl[_current_level]:
				var exp_to_add = _current_xp
				# NOTE. Remove current exp, cuz it will be added in add_xp()
				_current_xp -= _current_xp
				add_xp(exp_to_add)
