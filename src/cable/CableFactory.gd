extends Node

const CABLE: Resource = preload("res://src/cable/Cable.tscn")

enum CABLE_TYPES {
	CROSS,
	UP_RIGHT_LEFT,
	UP_DOWN,
	UP_RIGHT,
	RIGHT_LEFT
}

func create_cable(cable_type: int) -> Node2D:
	var cable = CABLE.instance()
	var edges: Dictionary = {
		"upArea": false,
		"rightArea": false,
		"downArea": false,
		"leftArea": false
	}
	match cable_type:
		CABLE_TYPES.CROSS:
			edges["upArea"] = true
			edges["rightArea"] = true
			edges["leftArea"] = true
			edges["downArea"] = true
		CABLE_TYPES.UP_RIGHT_LEFT:
			edges["upArea"] = true
			edges["rightArea"] = true
			edges["leftArea"] = true
		CABLE_TYPES.RIGHT_LEFT:
			edges["rightArea"] = true
			edges["leftArea"] = true
		CABLE_TYPES.UP_DOWN:
			edges["upArea"] = true
			edges["downArea"] = true
		CABLE_TYPES.UP_RIGHT:
			edges["upArea"] = true
			edges["rightArea"] = true

	for edge in edges.keys():
		cable.toggle_edge(edge, edges[edge])

	return cable
	
	
func create_random_cable() -> Node2D:
	randomize()
	var random: int = randi() % 5
	return create_cable(random)
	
