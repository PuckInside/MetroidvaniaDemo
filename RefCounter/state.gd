extends RefCounted
class_name IState

@warning_ignore("unused_signal")
signal finished

func _init() -> void:
	assert(false, "Нельзя создавать экземпляр у интерфеса")

func enter() -> void:
	pass

func exit() -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func handle_input(_event: InputEvent) -> void:
	pass
