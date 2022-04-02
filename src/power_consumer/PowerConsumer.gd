extends Node2D

export var CONSUMPTION_RATE: int
export var TTL: float = 60.0

var currentNode: Node2D = null
var groundNode: Node2D = null

var _state: bool = false
var _lived: float = 0

onready var currentArea: Area2D = $Current
onready var groundArea: Area2D = $Ground

func _ready() -> void:
	assert(CONSUMPTION_RATE > 0)
	
	
func set_power(state: bool) -> bool:
	if state:
		_lived = TTL
	_state = state
	return state


func is_powered() -> bool:
	return _state


func _on_Current_area_entered(area: Area2D) -> void:
	currentNode = area.get_parent()


func _on_Current_area_exited(area: Area2D) -> void:
	if area.get_parent() == currentNode:
		currentNode = null

