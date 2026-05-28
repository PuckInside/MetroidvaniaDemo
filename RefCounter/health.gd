extends RefCounted
class_name Health

signal health_changed(current_health: int)
signal death

var max_health: int
var health_point: int:
	set(value):
		health_point = clamp(value, 0, max_health)
		health_changed.emit(health_point)
		
		if health_point == 0:
			death.emit()

func _init(health: int) -> void:
	max_health = health
	health_point = max_health
