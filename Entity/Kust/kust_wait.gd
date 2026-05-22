extends IState
class_name KustWait

var _body: CharacterBody2D
var _triger: Area2D

func _init(body: CharacterBody2D, triger: Area2D) -> void:
	assert(body is CharacterBody2D, "Ссылка на сущность не должно быть пустым")
	assert(triger is Area2D, "Ссылка на тригер не должно быть пустым")
	
	_body = body
	_triger = triger
	_triger.body_entered.connect(_on_area_2d_body_entered)

func _on_area_2d_body_entered(body: Node) -> void:
	if not body is PlayerController:
		return
	
	finished.emit()
