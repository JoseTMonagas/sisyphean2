extends Node2D

# List of all posible cable types that can be generated
enum CABLE_TYPES {
	CROSS,
	RIGHT_DOWN_LEFT,
	RIGHT_DOWN,
	RIGHT_LEFT
}

# Maps where in the sprite sheet is the on and off variant of each cable type.
# where the first item in the array for any type would be the poweroff variant,
# and the second item is the poweron.
# Eg. Cross Cable: Power-on at index 11, Power-off at index 15.
const CABLE_TYPE_SPRITES: Dictionary = {
	CABLE_TYPES.CROSS: [15, 11],
	CABLE_TYPES.RIGHT_DOWN_LEFT: [13, 9],
	CABLE_TYPES.RIGHT_DOWN: [12, 8],
	CABLE_TYPES.RIGHT_LEFT: [14, 10]
}

export (CABLE_TYPES) var TYPE
export var CONSUMPTION_RATE: int = 1
export var TTL: float = .7 # Time To Live after being disconnected from power

var _state: bool = false setget set_power, is_powered
var _lived: float = 0.0

var upNode: Node2D = null
var downNode: Node2D = null
var rightNode: Node2D = null
var leftNode: Node2D = null

var edges: Dictionary = {
	"upArea": false,
	"rightArea": false,
	"downArea": false,
	"leftArea": false
}

onready var upArea: Area2D = $Up
onready var downArea: Area2D = $Down
onready var rightArea: Area2D = $Right
onready var leftArea: Area2D = $Left

onready var tween: Tween = $Tween
onready var sprite: Sprite = $Sprite

func _ready() -> void:
	assert(TYPE != null)
	_set_cable()


func _process(delta: float) -> void:
	if _lived > 0:
		_lived -= 1 * delta
	if _lived <= 0 and is_powered():
		set_power(false)


func set_power(state: bool) -> bool:
	if state:
		_lived = TTL
	_state = state
	# Because there are only 2 states for each cable type sprite, these can
	# be easily described using boolean 0 and 1 for the respective index.
	var index = int(state)
	sprite.frame = CABLE_TYPE_SPRITES[TYPE][index]
	return state


func is_powered() -> bool:
	return _state


func toggle_edge(edge: String, is_active: bool) -> void:
	var area: Area2D = get(edge)
	if not is_active:
		area.queue_free()

func _set_cable() -> void:
	match TYPE:
		CABLE_TYPES.CROSS:
			edges["upArea"] = true
			edges["rightArea"] = true
			edges["leftArea"] = true
			edges["downArea"] = true
		CABLE_TYPES.RIGHT_DOWN_LEFT:
			edges["rightArea"] = true
			edges["downArea"] = true
			edges["leftArea"] = true
		CABLE_TYPES.RIGHT_DOWN:
			edges["rightArea"] = true
			edges["downArea"] = true
		CABLE_TYPES.RIGHT_LEFT:
			edges["rightArea"] = true
			edges["leftArea"] = true

	for edge in edges.keys():
		toggle_edge(edge, edges[edge])

	sprite.frame = CABLE_TYPE_SPRITES[TYPE][0]


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
		upNode = null
		rightNode = null
		downNode = null
		leftNode = null
