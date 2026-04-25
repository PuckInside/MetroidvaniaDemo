extends Area2D
class_name HurtBox

const ZERO_DAMAGE := 0

@export var health: Health
@export var invincible = false

func _init() -> void:
	collision_layer = 0
	collision_mask = 2

func _ready() -> void:
	assert(health is Health)
	area_entered.connect(_on_area_entered)

func _on_area_entered(hitbox: Hitbox) -> void:
	if not hitbox is Hitbox:
		return
	
	if invincible:
		health.health_changed.emit(ZERO_DAMAGE)
		return
	
	health.take_damage(hitbox.damage)
