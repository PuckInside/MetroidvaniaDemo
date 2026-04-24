extends IState
class_name PlayerDashState

const NAME := "Dash"
const DASH_SPEED := 420.0
const JUMP_BUFFER := 0.520 #seconds

var _player: PlayerController
var _dash_distance: float
var _covered_distance: float

static func is_triggered() -> bool:
	return Input.is_action_just_pressed("dash")

func _init(body: PlayerController, dash_distance: float) -> void:
	assert(body is PlayerController, "Ссылка на игрока не должна быть пустым")
	
	name = NAME
	_player = body
	_dash_distance = dash_distance

func enter(_previous_state: String) -> void:
	if not _player.dash_available or not _player.dash_cooldown.is_stopped():
		return
	
	_covered_distance = 0.0
	_player.velocity.y = 0.0
	_player.velocity.x = 0.0
	_player.dash_available = false

func exit() -> void:
	_player.dash_cooldown.start()

func physics_update(_delta: float) -> void:
	if _covered_distance >= _dash_distance or _player.is_on_wall():
		if PlayerWalkState.is_triggered():
			state_machine.change_state(PlayerWalkState.NAME)
			return
		
		_player.velocity.x = 0.0
		state_machine.change_state(PlayerIdleState.NAME)
	
	var dash_velocity := Movement.get_move(_player.velocity, _player.last_direction, DASH_SPEED)
	_player.velocity = dash_velocity * _player.dash_curve.sample(_covered_distance / _dash_distance)
	_covered_distance += _player.velocity.abs().x * _delta

func handle_input(_event: InputEvent) -> void:
	if PlayerJumpState.is_triggered():
		_player.jump_buffer.start(JUMP_BUFFER)
