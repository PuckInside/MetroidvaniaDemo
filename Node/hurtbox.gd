extends Area2D
class_name HurtBox

signal damaged(damage: int, _force: Vector2, _duration: float)

func _init() -> void:
	collision_layer = 2
	collision_mask = 0

func take_damage(damage: int, _force: Vector2 = Vector2.ZERO, _duration: float = 0.2) -> void:
	damaged.emit(damage, _force, _duration)
