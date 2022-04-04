extends Node2D

export var CONSUMPTION_RATE: int
export var ACTIVE_ANIMATION: String
export var INACTIVE_ANIMATION: String
export var TTL: float = 15.0
export var SCORE_MULTIPLIER: int = 2

var currentNode: Node2D = null
var groundNode: Node2D = null

var _state: bool = false
var _lived: float = 0

onready var currentArea: Area2D = $Current
onready var animationPlayer: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	assert(CONSUMPTION_RATE > 0)
	assert(ACTIVE_ANIMATION)
	assert(INACTIVE_ANIMATION)
	
	
func _physics_process(delta: float) -> void:
	if not is_powered():
		_lived -= delta
		if _lived <= 0:
			set_power(false)
		
	
func set_power(state: bool) -> bool:
	if state:
		_lived = TTL
		animationPlayer.play(ACTIVE_ANIMATION)
	else:
		animationPlayer.play(INACTIVE_ANIMATION)
	_state = state
	return state


func is_powered() -> bool:
	return _state


func _on_Current_area_entered(area: Area2D) -> void:
	currentNode = area.get_parent()


func _on_Current_area_exited(area: Area2D) -> void:
	if area.get_parent() == currentNode:
		currentNode = null

