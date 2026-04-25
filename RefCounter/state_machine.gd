extends RefCounted
class_name StateMachine

var owner
var _states: Dictionary = {}
var _current_state: IState

func add_state(state: IState) -> void:
	_states[state.name] = state
	state.state_machine = self

func set_init_state(state_name: String) -> void:
	change_state(state_name)

func change_state(state_name: String) -> void:
	if _current_state:
		_current_state.exit()
	
	_current_state = _states.get(state_name)
	if _current_state:
		_current_state.enter(_current_state.name)
	else:
		push_warning("State not found: " + state_name)

func update(_delta: float) -> void:
	if _current_state:
		_current_state.update(_delta)

func physics_update(_delta: float) -> void:
	if _current_state:
		_current_state.physics_update(_delta)
	
func handle_input(_event: InputEvent) -> void:
	if _current_state:
		_current_state.handle_input(_event)

func get_state_name() -> String:
	return _current_state.name
