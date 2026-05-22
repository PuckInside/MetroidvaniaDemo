extends CharacterBody2D
class_name PlayerController

@export_group("Combat")
@export var max_health: int = 100
@export var melee_damage: int = 20
@export var range_damage: int = 75
@export var max_cartridges: int = 4

@export_group("Movement")
@export var move_speed: float = 640.0
@export var brake_speed: float = 720.0
@export var jump_height: float = 3 * 64.0
@export var jump_count: int = 1
@export var dash_distance: float = 5 * 64.0
@export var dash_speed: float = 1680.0
@export var dash_curve: Curve
@export var has_air_dash: bool = false

@onready var _coyote_timer: Timer = $CoyoteTime
@onready var _jump_buffer: Timer = $JumpBuffer
@onready var _dash_cooldown: Timer = $DashCooldown
@onready var _melee_hitbox: Hitbox = $meleeHitbox
@onready var _range_hitbox: Hitbox = $rangeHitbox
@onready var _attack_cooldown: Timer = $AttackCooldown
@onready var _shot_cooldown: Timer = $ShotCooldown

@onready var health: Health = Health.new(max_health)
@onready var cartridges: int = max_cartridges
@onready var facing: float = 1.0

enum States {
	IDLE,
	WALK,
	JUMP,
	DASH,
	MELEE_ATTACK,
	RANGE_ATTACK,
	KNOCKBACK,
}

var _state_machine: StateMachine
var _available_jumps: int = 0
var _dash_available: bool = false

func _init() -> void:
	var idle := PlayerIdleState.new(self, brake_speed)
	_state_machine = StateMachine.new(idle, States.IDLE)

func _ready() -> void:
	var walk := PlayerWalkState.new(self, move_speed)
	var jump := PlayerJumpState.new(self, jump_height, move_speed)
	var dash := PlayerDashState.new(self, dash_distance, dash_speed)
	var melee_attack := PlayerAttackState.new(self, _melee_hitbox, 0.1, 0.2)
	var range_attack := PlayerAttackState.new(self, _range_hitbox, 0.3, 0.5)
	
	for state: IState in [walk, jump, dash, melee_attack, range_attack]:
		state.finished.connect(_on_state_finished)
	
	_state_machine.add_state(walk, States.WALK)
	_state_machine.add_state(jump, States.JUMP)
	_state_machine.add_state(dash, States.DASH)
	_state_machine.add_state(melee_attack, States.MELEE_ATTACK)
	_state_machine.add_state(range_attack, States.RANGE_ATTACK)

func _physics_process(delta: float) -> void:
	if is_on_floor():
		_coyote_timer.start()
		
	if not _coyote_timer.is_stopped():
		_available_jumps = jump_count
		_dash_available = _dash_cooldown.is_stopped()
	else:
		_dash_available = has_air_dash and _dash_available
	
	if Input.get_axis("left", "right") and get_state_id() in [States.IDLE]:
		_state_machine.change_state(States.WALK)
	
	_state_machine.physics_update(delta)
	_handle_jump_buffer()
	move_and_slide()

func _handle_jump_buffer() -> void:
	if _jump_buffer.is_stopped():
		return
	if get_state_id() not in [States.IDLE, States.WALK]:
		return
	
	if _available_jumps >= 1:
		_state_machine.change_state(States.JUMP)
		_available_jumps -= 1
		_jump_buffer.stop()
		_coyote_timer.stop()

func _unhandled_input(event: InputEvent) -> void:
	_state_machine.handle_input(event)
	
	if event.is_action_pressed("jump"):
		_jump_buffer.start()
	
	if event.is_action_released("jump") and get_state_id() in [States.JUMP]:
		_on_state_finished()
	
	var can_dash_state = get_state_id() in [States.IDLE, States.WALK, States.JUMP]
	if event.is_action_pressed("dash") and _dash_available and can_dash_state:
		_state_machine.change_state(States.DASH)
		_dash_cooldown.start()
		_dash_available = false
	
	var can_attack_state = get_state_id() in [States.IDLE, States.WALK, States.JUMP]
	var can_attack = _attack_cooldown.is_stopped()
	if event.is_action_pressed("melee_attack") and can_attack_state and can_attack:
		_state_machine.change_state(States.MELEE_ATTACK)
		_attack_cooldown.start()
	
	var can_shoot = cartridges >= 1 and _shot_cooldown.is_stopped()
	if event.is_action_pressed("ranged_attack") and can_attack_state and can_shoot:
		_state_machine.change_state(States.RANGE_ATTACK)
		_shot_cooldown.start()
		cartridges -= 1

func get_state_id() -> int:
	return _state_machine.get_state_id()

func _on_state_finished() -> void:
	_state_machine.change_state(States.IDLE)

func _on_take_damage(damage: int, force: Vector2, duration: float):
	var knockback := KnockbackState.new(self, force, duration)
	health.health_point -= damage
	
	_state_machine.add_state(knockback, States.KNOCKBACK)
	_state_machine.change_state(States.KNOCKBACK)
	await knockback.finished
	
	_state_machine.change_state(States.IDLE)
	_state_machine.remove_state(States.KNOCKBACK)
