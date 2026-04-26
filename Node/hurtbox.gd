extends Area2D
class_name HurtBox

const ZERO_DAMAGE := 0

@export var health: Health
@export var invincible = false

func _init() -> void:
	collision_layer = 2
	collision_mask = 0

func _ready() -> void:
	assert(health is Health)

func take_damage(damage: int) -> void:
	if invincible:
		health.health_changed.emit(ZERO_DAMAGE)
		return
	
	if damage > 0.0:
		health.health_point -= damage
