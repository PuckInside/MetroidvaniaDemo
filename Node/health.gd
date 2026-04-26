extends Node
class_name Health

signal health_changed(current_health: int)
signal death

@export_range(1, 100, 1, "or_greater") 
var max_health: int = 100

@onready 
var health_point: int = max_health:
	set(value):
		if health_point == 0:
			death.emit()
			return
		
		health_point = clamp(value, 0, max_health)
		health_changed.emit(health_point)
