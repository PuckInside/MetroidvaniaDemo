extends CharacterBody2D
class_name PlayerController

@export_group("Movement")
@export var move_speed: float = 160.0
@export var brake_speed: float = 180.0
@export var jump_height: float = 3 * 16.0

@export_group("Dependency")
@export var coyote_timer: Timer 

@onready var state_machine: StateMachine = StateMachine.new()

var double_jump_available: bool = false
var on_floor: bool = false:
	set(value):
		if value == false:
			coyote_timer.stop()
			on_floor = false
		else:
			coyote_timer.start()
			on_floor = true
			double_jump_available = true

func _ready() -> void:
	assert(coyote_timer is Timer)
	
	var init_state := PlayerIdleState.new(self, brake_speed)
	state_machine.add_state(init_state)
	state_machine.set_init_state(init_state.name)
	
	state_machine.add_state(PlayerWalkState.new(self, move_speed))
	state_machine.add_state(PlayerJumpState.new(self, jump_height, move_speed))

func _physics_process(delta: float) -> void:
	_coyote_time_update()
	state_machine.physics_update(delta)
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	state_machine.handle_input(event)

func _coyote_time_update() -> void:
	if is_on_floor():
		on_floor = true
	if coyote_timer.is_stopped():
		on_floor = false
