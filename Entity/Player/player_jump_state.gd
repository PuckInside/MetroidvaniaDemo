extends IState
class_name PlayerJumpState

const NAME := "Jump"

var _player: PlayerController
var _jump_height: float
var _air_speed: float

static func is_triggered() -> bool:
	return Input.is_action_just_pressed("jump")

func _init(body: PlayerController, jump_height: float, air_speed: float) -> void:
	assert(body is PlayerController, "Ссылка на игрока не должна быть пустым")
	
	name = NAME
	_player = body
	_jump_height = jump_height
	_air_speed = air_speed

func physics_update(_delta: float) -> void:
	_player.velocity = Movement.get_gravity(_player.velocity, _delta)
	
	if _player.velocity.y >= 0.0:
		state_machine.change_state(PlayerIdleState.NAME)
		return
	
	var direction = _player.get_direction()
	if direction:
		_player.velocity = Movement.get_move(_player.velocity, direction, _air_speed)
	else:
		_player.velocity = Movement.get_brake(_player.velocity, _air_speed)

func handle_input(_event: InputEvent) -> void:
	if _event.is_action_released("jump"):
		state_machine.change_state(PlayerIdleState.NAME)
		return

func enter(_previous_state: String) -> void:
	if _player.on_floor:
		_player.velocity = Movement.get_jump(_player.velocity, _jump_height)
		_player.on_floor = false
		return
	
	if _player.double_jump_available:
		_player.velocity = Movement.get_jump(_player.velocity, _jump_height)
		_player.double_jump_available = false
		return
	
	state_machine.change_state(PlayerIdleState.NAME)

func exit() -> void:
	_player.velocity = Movement.get_jump_cut(_player.velocity)
