extends IState
class_name PlayerShotState

const NAME := "Shot"
const POSITION := 600.0
const BRAKE_SPEED := 350.0

var _player: PlayerController
var _prepare: float
var _duration: float

static func is_triggered() -> bool:
	return Input.is_action_just_pressed("ranged_attack")

func physics_update(_delta: float) -> void:
	if not _player.on_floor:
		_player.velocity = Movement.get_gravity(_player.velocity, _delta)
	
	_player.velocity = Movement.get_brake(_player.velocity, BRAKE_SPEED)

func _init(body: PlayerController, prepare: float, duration: float) -> void:
	assert(body is PlayerController, "Ссылка на игрока не должна быть пустым")
	
	name = NAME
	_player = body
	_prepare = prepare
	_duration = duration

func enter(_previous_state: String) -> void:
	if _player.cartridges <= 0:
		state_machine.change_state(PlayerIdleState.NAME)
		return
	
	if not _player.shot_cooldown.is_stopped():
		state_machine.change_state(PlayerIdleState.NAME)
		return
	
	await _player.get_tree().create_timer(_prepare).timeout
	
	_player.range_hitbox.position.x = _player.last_direction * POSITION
	_player.range_hitbox.deal_damage(_duration)
	await _player.get_tree().create_timer(_duration).timeout
	
	_player.shot_cooldown.start()
	_player.cartridges -= 1
	print(_player.cartridges)
	#_player.velocity = Movement.get_move(_player.velocity, _player.last_direction, MOVE)
	state_machine.change_state(PlayerIdleState.NAME)
