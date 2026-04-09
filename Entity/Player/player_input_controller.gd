extends Node
class_name PlayerInputController

const IDLE := 0.0
const LEFT := -1.0
const RIGHT := 1.0

signal jump_just_pressed
signal jump_just_released
signal dash

var move_direction: float = IDLE

func _unhandled_input(_event: InputEvent) -> void:
	if _event.is_action_pressed("jump"):
		jump_just_pressed.emit()
	if _event.is_action_released("jump"):
		jump_just_released.emit()
	
	if _event.is_action_pressed("dash"):
		dash.emit()

func _process(_delta: float) -> void:
	move_direction = IDLE
	
	if Input.is_action_pressed("left"):
		move_direction = LEFT
	if Input.is_action_pressed("right"):
		move_direction = RIGHT
