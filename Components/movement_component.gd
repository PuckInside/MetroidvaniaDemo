extends Node
class_name MovementComponent

@export_group("Direct")
@export var move_speed: float = 150.0
@export var jump_height: float = 3 * 16.0
@export var jump_cut_ratio := 0.6

@export_group("Indirect")
@export var acceleration := 0.15
@export var brake_speed := 180.0
@export var gravity_velocity := 980.0
@export var fall_limit := 420.0

func get_gravity(velocity: Vector2, delta: float) -> Vector2:
	if velocity.y < fall_limit:
		velocity.y += gravity_velocity * delta
	
	return velocity

func get_brake(velocity: Vector2) -> Vector2:
	velocity.x = move_toward(velocity.x, 0.0, brake_speed * acceleration)
	return velocity

func get_move(velocity: Vector2, direction: float) -> Vector2:
	velocity.x = move_toward(velocity.x, direction * move_speed, move_speed * acceleration)
	return velocity

func get_jump(velocity: Vector2, height: float = jump_height) -> Vector2:
	velocity.y -= sqrt(2.0 * gravity_velocity * height)
	return velocity

func get_jump_cut(velocity: Vector2) -> Vector2:
	velocity.y *= jump_cut_ratio
	return velocity
