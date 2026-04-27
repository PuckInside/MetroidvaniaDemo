extends RefCounted
class_name Movement

const ZERO := 0.0
const GRAVITY := 980.0 * 4

static func get_gravity(velocity: Vector2, delta: float) -> Vector2:
	velocity.y += GRAVITY * delta
	return velocity

static func get_move(velocity: Vector2, direction: float, speed: float) -> Vector2:
	if direction:
		velocity.x = move_toward(velocity.x, direction * speed, speed * 0.16)
	
	return velocity

static func get_brake(velocity: Vector2, brake_speed: float) -> Vector2:
	velocity.x = move_toward(velocity.x, ZERO, brake_speed * 0.15)
	return velocity

static func get_jump(velocity: Vector2, jump_height: float) -> Vector2:
	velocity.y = -sqrt(2.0 * GRAVITY * jump_height)
	return velocity

static func get_jump_cut(velocity: Vector2, ratio: float = 0.5) -> Vector2:
	if velocity.y < ZERO:
		velocity.y *= ratio
	
	return velocity
