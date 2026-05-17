extends HurtBox
class_name PlayerHurtBox

@export var alt_frame: float = 0.2 
var _alt_frame_timer: ManualTimer = ManualTimer.new()

func _physics_process(delta: float) -> void:
	_alt_frame_timer.update_timer(delta)
	invincible = not _alt_frame_timer.is_stopped()

func take_damage(damage: int, _force: Vector2 = Vector2.ZERO, _duration: float = 0.2) -> void:
	if invincible:
		health.health_changed.emit(ZERO_DAMAGE)
		return
	
	if damage > 0.0:
		health.health_point -= damage
		enter_alt_frames(alt_frame)
		(health.owner as PlayerController).force_knockback(_force, _duration)

func enter_alt_frames(duration: float) -> void:
	_alt_frame_timer.start(duration)
