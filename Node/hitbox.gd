extends Area2D
class_name Hitbox

@export var damage: int = 0

func _init() -> void:
	collision_layer = 0
	collision_mask = 2

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(hurtbox: HurtBox) -> void:
	if not hurtbox is HurtBox:
		return
	
	hurtbox.take_damage(damage)
