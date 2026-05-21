extends IState
class_name PlayerJumpState

var _player: PlayerController
var _jump_height: float
var _air_speed: float

func _init(body: PlayerController, jump_height: float, air_speed: float) -> void:
	assert(body is PlayerController, "Ссылка на игрока не должна быть пустым")
	
	_player = body
	_jump_height = jump_height
	_air_speed = air_speed

func physics_update(_delta: float) -> void:
	_player.velocity = Movement.get_gravity(_player.velocity, _delta)
	
	if _player.velocity.y >= 0.0:
		finished.emit()
		return
	
	var direction = Input.get_axis("left", "right")
	if direction:
		_player.facing = direction
		_player.velocity = Movement.get_move(_player.velocity, direction, _air_speed)
	else:
		_player.velocity = Movement.get_brake(_player.velocity, _air_speed)

func enter() -> void:
	_player.velocity = Movement.get_jump(_player.velocity, _jump_height)

func exit() -> void:
	_player.velocity = Movement.get_jump_cut(_player.velocity)
