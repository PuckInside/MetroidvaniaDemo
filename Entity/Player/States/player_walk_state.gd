extends IState
class_name PlayerWalkState

var _player: PlayerController
var _move_speed: float = 640.0

func _init(body: PlayerController, move_speed: float) -> void:
	assert(body is PlayerController, "Ссылка на игрока не должна быть пустым")
	
	_player = body
	_move_speed = move_speed

func physics_update(_delta: float) -> void:
	if  not _player.is_on_floor():
		_player.velocity = Movement.get_gravity(_player.velocity, _delta)
	
	var direction = Input.get_axis("left", "right")
	if not direction: 
		finished.emit()
		return
	
	_player.facing = direction
	_player.velocity = Movement.get_move(_player.velocity, direction, _move_speed)
