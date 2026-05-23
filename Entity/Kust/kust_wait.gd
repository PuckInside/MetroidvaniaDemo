extends IState
class_name KustWait

var _body: CharacterBody2D
var _triger: Area2D
var _timer: ManualTimer
var _bite_cooldown: float

func _init(body: CharacterBody2D, triger: Area2D, cooldown: float) -> void:
	assert(body is CharacterBody2D, "Ссылка на сущность не должно быть пустым")
	assert(triger is Area2D, "Ссылка на тригер не должно быть пустым")
	
	_body = body
	_triger = triger
	_timer = ManualTimer.new()
	_bite_cooldown = cooldown

func physics_update(_delta: float) -> void:
	_timer.update_timer(_delta)
	if not _timer.is_stopped():
		return
	
	var bodies := _triger.get_overlapping_bodies()
	for body in bodies:
		if body is PlayerController:
			_timer.start(_bite_cooldown)
			finished.emit()
