extends IState
class_name PlayerIdleState

const NAME := "Idle"

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
	
	if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		state_machine.change_state(PlayerWalkState.NAME)
		return
	else:
		_player.velocity = Movement.get_brake(_player.velocity, _brake_speed)

func handle_input(_event: InputEvent) -> void:
	if _event.is_action_pressed("jump"):
		state_machine.change_state(PlayerJumpState.NAME)
