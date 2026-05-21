extends Area2D
class_name HurtBox

signal damaged(damage: int, _force: Vector2, _duration: float)
const ZERO_DAMAGE := 0

@export var invincible = false

func _init() -> void:
	collision_layer = 2
	collision_mask = 0

func take_damage(damage: int, _force: Vector2 = Vector2.ZERO, _duration: float = 0.2) -> void:
	if invincible:
		damaged.emit(ZERO_DAMAGE, Vector2.ZERO, 0.0)
		return
	
	damaged.emit(damage, _force, _duration)
