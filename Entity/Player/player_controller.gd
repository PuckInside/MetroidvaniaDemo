extends CharacterBody2D
class_name PlayerController

const NO_JUMPING_MAP := [
	PlayerDashState.NAME, 
	PlayerKnockbackState.NAME, 
	PlayerAttackState.NAME,
	PlayerShotState.NAME,
]

@export_group("Movement")
@export var move_speed: float = 640.0
@export var brake_speed: float = 720.0
@export var double_jump: bool = false
@export var jump_height: float = 3 * 64.0
@export var dash_distance: float = 5 * 64.0
@export var dash_curve: Curve

@export var health: Health
@onready var melee_hitbox: Hitbox = $meleeHitbox
@onready var range_hitbox: Hitbox = $rangeHitbox
@onready var coyote_timer: Timer = $CoyoteTime
@onready var jump_buffer: Timer = $JumpBuffer
@onready var dash_cooldown: Timer = $DashCooldown
@onready var attack_cooldown: Timer = $AttackCooldown
@onready var shot_cooldown: Timer = $ShotCooldown

var _state_machine: StateMachine = StateMachine.new()

var cartridges: int = 5
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
			double_jump_available = double_jump
			dash_available = true

func _ready() -> void:
	assert(dash_curve is Curve)
	assert(health is Health)
	
	var init_state := PlayerIdleState.new(self, brake_speed)
	_state_machine.add_state(init_state)
	_state_machine.set_init_state(init_state.name)
	
	_state_machine.add_state(PlayerWalkState.new(self, move_speed))
	_state_machine.add_state(PlayerJumpState.new(self, jump_height, move_speed))
	_state_machine.add_state(PlayerDashState.new(self, dash_distance))
	_state_machine.add_state(PlayerKnockbackState.new(self))
	_state_machine.add_state(PlayerAttackState.new(self, 0.1, 0.2))
	_state_machine.add_state(PlayerShotState.new(self, 0.3, 0.5))

func _physics_process(delta: float) -> void:
	_coyote_time_update()
	_jump_buffering()
	_state_machine.physics_update(delta)
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	_state_machine.handle_input(event)

func _coyote_time_update() -> void:
	if is_on_floor():
		on_floor = true
	if coyote_timer.is_stopped():
		on_floor = false

func _jump_buffering() -> void:
	if _state_machine.get_state_name() in NO_JUMPING_MAP:
		return
	if jump_buffer.is_stopped():
		return
	
	if on_floor or double_jump_available:
		jump_buffer.stop()
		_state_machine.change_state(PlayerJumpState.NAME)

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

func force_knockback(force_velocity: Vector2, duration: float) -> void:
	var knockback = _state_machine._states.get(PlayerKnockbackState.NAME)
	if not knockback is PlayerKnockbackState:
		return
	
	(knockback as PlayerKnockbackState).setup(force_velocity, duration)
	_state_machine.change_state(PlayerKnockbackState.NAME)

func get_state() -> String:
	return _state_machine.get_state_name()
