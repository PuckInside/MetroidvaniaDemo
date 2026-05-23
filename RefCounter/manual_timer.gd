extends RefCounted
class_name ManualTimer

signal finished

var _wait_time: float = 0.0
var _timer: float = 0.0
var _stopped: bool = true

func start(wait_time: float) -> void:
	_wait_time = wait_time
	_timer = 0.0
	_stopped = false

func stop() -> void:
	_wait_time = 0.0
	_timer = 0.0
	_stopped = true
	finished.emit()

func update_timer(_delta: float) -> void:
	if _stopped:
		return
	
	if _timer >= _wait_time: 
		stop()
	
	_timer += _delta

func is_stopped() -> bool:
	return _stopped
