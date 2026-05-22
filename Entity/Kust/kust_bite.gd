extends IState
class_name KustBite

var _body: CharacterBody2D
var _prepare: float
var _duration: float
var _hitbox: Hitbox

func _init(body: CharacterBody2D, hitbox: Hitbox, prepare: float, duration: float) -> void:
		assert(body is CharacterBody2D, "Ссылка на игрока не должна быть пустым")
		assert(hitbox is Hitbox, "Ссылка на игрока не должна быть пустым")
		
		_body = body
		_hitbox = hitbox
		_prepare = prepare
		_duration = duration
	
func enter() -> void:
		await _body.get_tree().create_timer(_prepare).timeout
		_hitbox.deal_damage(_duration)
		await _body.get_tree().create_timer(_duration).timeout
		finished.emit()
