extends IState
class_name KnockbackState

var _body: CharacterBody2D
var _timer: ManualTimer
var _force_velocity: Vector2
var _duration: float

func _init(body: CharacterBody2D, force_velocity: Vector2, duration: float) -> void:
	assert(body is CharacterBody2D, "Ссылка на сущность не должно быть пустым")
	
	_body = body
	_timer = ManualTimer.new()
	_force_velocity = force_velocity
	_duration = duration

func physics_update(_delta: float) -> void:
	if _timer.is_stopped():
		finished.emit()
	
	_body.velocity = Movement.get_gravity(_body.velocity, _delta)
	_body.velocity = Movement.get_brake(_body.velocity, 720.0)
	_timer.update_timer(_delta)

func enter() -> void:
	_body.velocity = _force_velocity
	_timer.start(_duration)
