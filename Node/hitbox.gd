extends Area2D
class_name Hitbox

@export var damage: int = 0

func _init() -> void:
	collision_layer = 2
	collision_mask = 0
