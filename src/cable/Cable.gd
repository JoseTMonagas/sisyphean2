extends Node2D

export var CONSUMPTION_RATE: int = 1
export var TTL: float = 60.0 # Time To Live after being disconnected from power

var _state: bool = false setget set_power, is_powered
var _lived: float = 0.0

var upNode: Node2D = null
var downNode: Node2D = null
var rightNode: Node2D = null
var leftNode: Node2D = null

onready var upArea: Area2D = $Up
onready var downArea: Area2D = $Down
onready var rightArea: Area2D = $Right
onready var leftArea: Area2D = $Left
onready var tween: Tween = $Tween

func _process(delta: float) -> void:
	if _lived > 0:
		_lived -= 1 * delta
		
	if _lived <= 0 and not is_powered():
		set_power(false)


func set_power(state: bool) -> bool:
	if state:
		_lived = TTL
	_state = state
	return state


func is_powered() -> bool:
	return _state


func toggle_edge(edge: String, is_active: bool) -> void:
	var area: Area2D = get(edge)
	area.monitoring = is_active
	area.monitorable = is_active


func _on_Edge_area_entered(area: Area2D, edge: String) -> void:
	# When any of the 4 cardinal edges contacts another area, it will send
	# a signal including the contacted area, and which edge did it,
	# so that edge can store the parent (The actual node).
	# area: Area2D. Any of `Cable`, `PowerGenerator`, `Room`.
	# edge: String. Any of `upNode`, `downNode`, `leftNode`, `rightNode`.
	set(edge, area.get_parent())


func _on_Edge_area_exited(area: Area2D, edge: String) -> void:
	# When an edge is not longer in contact with any other area, remove that
	# area's parent from the connected node.
	if get(edge) == area.get_parent():
		set(edge, null)


func _on_ClickArea_input_event(
	viewport: Node,
	event: InputEvent,
	shape_idx: int
) -> void:
	# When the player clicks the node and if there aren't any animation running
	# at the moment, then rotate 90 degrees with a small bounce animation.
	if event.is_action_pressed("click") and not tween.is_active():
		tween.interpolate_property(
			self,
			"rotation_degrees",
			rotation_degrees,
			rotation_degrees + 90,
			0.5,
			Tween.TRANS_ELASTIC,
			Tween.EASE_IN_OUT
		)
		tween.start()
