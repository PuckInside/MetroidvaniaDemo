extends Node
class_name Health

signal health_changed(current_health: int)
signal death

@export_range(1, 100, 1, "or_greater") 
var max_health: int = 100

@onready var health: int = max_health:
	set(value):
		health = clamp(value, 0, max_health)
		health_changed.emit(health)
		if health == 0:
			death.emit()

func take_damage(amount: int) -> void:
	if amount <= 0.0:
		return
	health -= amount

func heal(amount: int) -> void:
	if amount <= 0.0:
		return
	health += amount
