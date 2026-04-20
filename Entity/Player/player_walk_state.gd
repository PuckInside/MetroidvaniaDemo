extends IState
class_name PlayerWalkState

const NAME := "Walk"

var _player: PlayerController
var _move_speed: float

func _init(body: PlayerController, move_speed: float) -> void:
	assert(body is PlayerController, "Ссылка на игрока не должна быть пустым")
	
	name = NAME
	_player = body
	_move_speed = move_speed

func physics_update(_delta: float) -> void:
	if not _player.on_floor:
		_player.velocity = Movement.get_gravity(_player.velocity, _delta)
	
	var direction = _get_direction()
	if not direction:
		state_machine.change_state(PlayerIdleState.NAME)
		return
	
	_player.velocity = Movement.get_move(_player.velocity, direction, _move_speed)

func handle_input(_event: InputEvent) -> void:
	if _event.is_action_pressed("jump"):
		state_machine.change_state(PlayerJumpState.NAME)

func _get_direction() -> float:
	if Input.is_action_pressed("left"):
		return -1.0
	if Input.is_action_pressed("right"):
		return 1.0
	
	return 0.0
