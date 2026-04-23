extends IState
class_name PlayerDashState

const NAME := "Dash"
const DASH_SPEED := 480.0
const JUMP_BUFFER := 0.320 #seconds

var _player: PlayerController
var _dash_distance: float
var _jump_buffer: ManualTimer = ManualTimer.new()

func _init(body: PlayerController, dash_distance: float) -> void:
	assert(body is PlayerController, "Ссылка на игрока не должна быть пустым")
	
	name = NAME
	_player = body
	_dash_distance = dash_distance

func handle_input(_event: InputEvent) -> void:
	if PlayerJumpState.is_triggered():
		_jump_buffer.start(JUMP_BUFFER)
