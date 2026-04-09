extends CharacterBody2D
class_name PlayerController

@export var input: PlayerInputController
@export var movement: MovementComponent

func _ready() -> void:
	assert(input is PlayerInputController)
	assert(movement is MovementComponent)
	
	input.jump_just_pressed.connect(_on_jump_pressed)
	input.jump_just_released.connect(_on_jump_released)

func _physics_process(_delta: float) -> void:
	if input.move_direction:
		velocity = movement.get_move(velocity, input.move_direction)
	else:
		velocity = movement.get_brake(velocity)
	
	if not is_on_floor():
		velocity = movement.get_gravity(velocity, _delta)
	
	move_and_slide()

func _on_jump_pressed() -> void:
	if is_on_floor():
		velocity = movement.get_jump(velocity)

func _on_jump_released() -> void:
	if velocity.y < 0:
		velocity = movement.get_jump_cut(velocity)
