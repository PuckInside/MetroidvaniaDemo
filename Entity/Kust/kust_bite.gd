extends IState
class_name KustBite

var _body: CharacterBody2D
var _prepare: float
var _duration: float
var _hitbox: Hitbox
var _prepare_timer: ManualTimer
var _duration_timer: ManualTimer

func _init(body: CharacterBody2D, hitbox: Hitbox, prepare: float, duration: float) -> void:
		assert(body is CharacterBody2D, "Ссылка на игрока не должна быть пустым")
		assert(hitbox is Hitbox, "Ссылка на игрока не должна быть пустым")
		
		_body = body
		_hitbox = hitbox
		_prepare = prepare
		_duration = duration
		_prepare_timer = ManualTimer.new()
		_duration_timer = ManualTimer.new()
		_prepare_timer.finished.connect(func(): _hitbox.deal_damage(0.1))
		_prepare_timer.finished.connect(func(): _duration_timer.start(_duration))

func physics_update(_delta: float) -> void:
	_prepare_timer.update_timer(_delta)
	_duration_timer.update_timer(_delta)

func enter() -> void:
	_duration_timer.stop()
	_prepare_timer.start(_prepare)
	
	await _duration_timer.finished
	finished.emit()
