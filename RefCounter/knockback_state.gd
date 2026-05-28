extends IState
class_name KnockbackState

var _body: CharacterBody2D
var _timer: ManualTimer
var _force_velocity: Vector2 = Vector2.ZERO
var _duration: float = 0.0

func _init(body: CharacterBody2D) -> void:
	assert(body is CharacterBody2D, "Ссылка на сущность не должно быть пустым")
	
	_body = body
	_timer = ManualTimer.new()
	_timer.finished.connect(func(): finished.emit())

func physics_update(_delta: float) -> void:
	_body.velocity = Movement.get_gravity(_body.velocity, _delta)
	_body.velocity = Movement.get_brake(_body.velocity, 720.0)
	_timer.update_timer(_delta)

func setup(force: Vector2, duration: float):
	_force_velocity = force
	_duration = duration

func enter() -> void:
	if _force_velocity:
		_body.velocity = _force_velocity
	_timer.start(_duration)

func exit() -> void:
	_force_velocity = Vector2.ZERO
	_duration = 0.0
