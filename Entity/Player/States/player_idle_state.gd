extends IState
class_name PlayerIdleState

var _player: PlayerController
var _brake_speed: float

func _init(body: PlayerController, brake_speed: float) -> void:
	assert(body is PlayerController, "Ссылка на игрока не должна быть пустым")
	
	_player = body
	_brake_speed = brake_speed

func physics_update(_delta: float) -> void:
	if not _player.is_on_floor():
		_player.velocity = Movement.get_gravity(_player.velocity, _delta)
	
	_player.velocity = Movement.get_brake(_player.velocity, _brake_speed)
