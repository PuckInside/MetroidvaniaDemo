extends RefCounted
class_name StateMachine

var _states: Dictionary[int, IState] = {}
var _current_state: IState

func _init(state: IState, id: int) -> void:
	add_state(state, id)
	_current_state = _states.get(id)

func add_state(state: IState, id: int) -> void:
	_states[id] = state

func remove_state(id: int) -> void:
	if id == get_state_id():
		push_error("Нельзя удалять активное состояние!")
		return
	
	_states.erase(id)

func change_state(id: int) -> void:
	assert(_current_state is IState)
	
	_current_state.exit()
	_current_state = _states.get(id)
	_current_state.enter()

func update(_delta: float) -> void:
	_current_state.update(_delta)

func physics_update(_delta: float) -> void:
	_current_state.physics_update(_delta)
	
func handle_input(_event: InputEvent) -> void:
	_current_state.handle_input(_event)

func get_state_id() -> int:
	return _states.find_key(_current_state)
