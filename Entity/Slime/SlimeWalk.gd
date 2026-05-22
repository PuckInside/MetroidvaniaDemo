extends IState
class_name SlimeWalk

var _move_speed: float = 640.0
var _body: CharacterBody2D
	
func _init(body: CharacterBody2D, move_speed: float) -> void:
	assert(body is CharacterBody2D, "Ссылка на сущность не должно быть пустым")
	
	_body = body
	_move_speed = move_speed
	
func physics_update(_delta: float) -> void:
	if not _body.is_on_floor():
		_body.velocity = Movement.get_gravity(_body.velocity, _delta)
	
	_body.velocity = Movement.get_move(_body.velocity, _body.facing, _move_speed)
