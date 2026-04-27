extends IState
class_name PlayerWalkState

const NAME := "Walk"
const JUMP_BUFFER := 0.120 #seconds

var _player: PlayerController
var _move_speed: float = 640.0

static func is_triggered() -> bool:
	if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		return true
	else:
		return false

func _init(body: PlayerController, move_speed: float) -> void:
	assert(body is PlayerController, "Ссылка на игрока не должна быть пустым")
	
	name = NAME
	_player = body
	_move_speed = move_speed

func physics_update(_delta: float) -> void:
	if not _player.on_floor:
		_player.velocity = Movement.get_gravity(_player.velocity, _delta)
	
	var direction = _player.get_direction()
	if not direction:
		state_machine.change_state(PlayerIdleState.NAME)
		return
	
	_player.velocity = Movement.get_move(_player.velocity, direction, _move_speed)

func handle_input(_event: InputEvent) -> void:
	if PlayerJumpState.is_triggered():
		_player.jump_buffer.start(JUMP_BUFFER)
		return
	
	if PlayerDashState.is_triggered():
		state_machine.change_state(PlayerDashState.NAME)
		return
