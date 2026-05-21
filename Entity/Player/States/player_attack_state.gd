extends IState
class_name PlayerAttackState

const BRAKE_SPEED := 350.0

var _player: PlayerController
var _hitbox: Hitbox
var _hitbox_position: float
var _attack_point: float
var _attack_backswing: float

func physics_update(_delta: float) -> void:
	if not _player.is_on_floor():
		_player.velocity = Movement.get_gravity(_player.velocity, _delta)
	
	_player.velocity = Movement.get_brake(_player.velocity, BRAKE_SPEED)

func _init(body: PlayerController, hitbox: Hitbox, point: float, backswing: float) -> void:
	assert(body is PlayerController, "Ссылка на игрока не должна быть пустым")
	assert(hitbox is Hitbox, "Ссылка на хитбокс не должна быть пустым")
	
	_player = body
	_hitbox = hitbox
	_hitbox_position = _hitbox.position.x
	_attack_point = point
	_attack_backswing = backswing

func enter() -> void:
	await _player.get_tree().create_timer(_attack_point).timeout
	_hitbox.position.x = _player.facing * _hitbox_position
	_hitbox.deal_damage(0.2)
	
	await _player.get_tree().create_timer(_attack_backswing).timeout
	finished.emit()
