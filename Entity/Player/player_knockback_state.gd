extends IState
class_name PlayerKnockbackState

const NAME := "Knockback"

var _player: PlayerController
var _timer: ManualTimer
var _force_velocity: Vector2
var _duration: float

func _init(body: PlayerController) -> void:
	assert(body is PlayerController, "Ссылка на игрока не должна быть пустым")
	
	name = NAME
	_player = body
	_timer = ManualTimer.new()
	_force_velocity = Vector2.ZERO
	_duration = 0.0

func setup(force_velocity: Vector2, duration: float) -> void:
	_force_velocity = force_velocity
	_duration = duration

func physics_update(_delta: float) -> void:
	if _timer.is_stopped():
		_player.state_machine.change_state(PlayerIdleState.NAME)
	
	_player.velocity = Movement.get_gravity(_player.velocity, _delta)
	_player.velocity = Movement.get_brake(_player.velocity, _player.brake_speed)
	_timer.update_timer(_delta)

func enter(_previous_state: String) -> void:
	_player.velocity = _force_velocity
	_timer.start(_duration)
