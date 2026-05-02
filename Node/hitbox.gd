extends Area2D
class_name Hitbox

@export var force_height: float = 0.0
@export var force_velocity: float = 0.0
@export var disable_duration: float = 0.0
@export var damage: int = 0
@export var is_always_active: bool = false

func _init() -> void:
	collision_layer = 0
	collision_mask = 2

func _ready() -> void:
	monitoring = is_always_active
	area_entered.connect(_on_area_entered)

func deal_damage(lifetime: float) -> void:
	monitoring = true
	await get_tree().create_timer(lifetime).timeout
	monitoring = is_always_active

func _on_area_entered(hurtbox: HurtBox) -> void:
	if not hurtbox is HurtBox:
		return
	if hurtbox.owner == self.owner or hurtbox.owner == self:
		return
	
	var self_pos = self.global_position 
	var target_pos = hurtbox.global_position
	var direction = sign(target_pos.x - self_pos.x)
	
	var velocity = Vector2(direction * force_velocity, 0.0)
	velocity = Movement.get_jump(velocity, force_height)
	hurtbox.take_damage(damage, velocity, disable_duration)
	
