extends IState
class_name PlayerDashState

var _player: PlayerController
var _dash_speed: float
var _dash_distance: float
var _covered_distance: float

func _init(body: PlayerController, dash_distance: float, dash_speed: float) -> void:
	assert(body is PlayerController, "Ссылка на игрока не должна быть пустым")
	
	_player = body
	_dash_speed = dash_speed
	_dash_distance = dash_distance

func enter() -> void:
	_covered_distance = 0.0
	_player.velocity.y = 0.0
	_player.velocity.x = 0.0

func physics_update(_delta: float) -> void:
	if _covered_distance >= _dash_distance or _player.is_on_wall():
		if not Input.get_axis("left", "right"): _player.velocity.x = 0.0
		finished.emit()
		return
	
	var dash_velocity := Movement.get_move(_player.velocity, _player.facing, _dash_speed)
	_player.velocity = dash_velocity * _player.dash_curve.sample(_covered_distance / _dash_distance)
	_covered_distance += _player.velocity.abs().x * _delta
