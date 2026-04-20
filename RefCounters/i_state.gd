extends RefCounted
class_name IState

var name: String = "State"
var state_machine: StateMachine

func _init() -> void:
	assert(false, "Нельзя создавать экземпляр у интерфеса")

func enter(_previous_state: String) -> void:
	pass

func exit() -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func handle_input(_event: InputEvent) -> void:
	pass
