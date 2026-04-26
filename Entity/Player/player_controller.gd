extends CharacterBody2D
class_name PlayerController

const NO_JUMPING_MAP := [PlayerDashState.NAME, ]

@export_group("Movement")
@export var move_speed: float = 160.0
@export var brake_speed: float = 180.0
@export var jump_height: float = 3 * 16.0
@export var dash_distance: float = 5 * 16.0

@export_group("Dependency")
@export var health: Health
@export var coyote_timer: Timer
@export var jump_buffer: Timer
@export var dash_curve: Curve
@export var dash_cooldown: Timer

var state_machine: StateMachine = StateMachine.new()

var last_direction: float = 1.0
var double_jump_available: bool = false
var dash_available: bool = false

var on_floor: bool = false:
	set(value):
		if value == false:
			coyote_timer.stop()
			on_floor = false
		else:
			coyote_timer.start()
			on_floor = true
			double_jump_available = true
			dash_available = true

func _ready() -> void:
	assert(health is Health)
	assert(coyote_timer is Timer)
	assert(jump_buffer is Timer)
	assert(dash_curve is Curve)
	assert(dash_cooldown is Timer)
	
	health.health_changed.connect(_on_health_changed)
	health.death.connect(_on_dealth)
	
	var init_state := PlayerIdleState.new(self, brake_speed)
	state_machine.add_state(init_state)
	state_machine.set_init_state(init_state.name)
	
	state_machine.add_state(PlayerWalkState.new(self, move_speed))
	state_machine.add_state(PlayerJumpState.new(self, jump_height, move_speed))
	state_machine.add_state(PlayerDashState.new(self, dash_distance))

func _physics_process(delta: float) -> void:
	_coyote_time_update()
	_jump_buffering()
	state_machine.physics_update(delta)
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	state_machine.handle_input(event)

func _coyote_time_update() -> void:
	if is_on_floor():
		on_floor = true
	if coyote_timer.is_stopped():
		on_floor = false

func _jump_buffering() -> void:
	if state_machine.get_state_name() in NO_JUMPING_MAP:
		return
	if jump_buffer.is_stopped():
		return
	
	if on_floor or double_jump_available:
		jump_buffer.stop()
		state_machine.change_state(PlayerJumpState.NAME)

func get_direction() -> float:
	var is_left = Input.is_action_pressed("left")
	var is_right = Input.is_action_pressed("right")
	
	if is_left and is_right:
		if Input.is_action_just_pressed("left"):
			last_direction = -1.0
		if Input.is_action_just_pressed("right"):
			last_direction = 1.0
		
		return last_direction
	
	if is_left:
		last_direction = -1.0
		return -1.0
	
	if is_right:
		last_direction = 1.0
		return 1.0
	
	return 0.0

func _on_dealth() -> void:
	print("Dealth!")

func _on_health_changed(current_health: int) -> void:
	print(current_health)
