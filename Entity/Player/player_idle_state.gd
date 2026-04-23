extends IState
class_name PlayerIdleState

const NAME := "Idle"
const JUMP_BUFFER := 0.120 #seconds

var _player: PlayerController
var _brake_speed: float

func _init(body: PlayerController, brake_speed: float) -> void:
	assert(body is PlayerController, "Ссылка на игрока не должна быть пустым")
	
	name = NAME
	_player = body
	_brake_speed = brake_speed

func physics_update(_delta: float) -> void:
	if not _player.on_floor:
		_player.velocity = Movement.get_gravity(_player.velocity, _delta)
	
	if PlayerWalkState.is_triggered():
		state_machine.change_state(PlayerWalkState.NAME)
		return
	
	_player.velocity = Movement.get_brake(_player.velocity, _brake_speed)

func handle_input(_event: InputEvent) -> void:
	if PlayerJumpState.is_triggered():
		_player.jump_buffer.start(JUMP_BUFFER)
