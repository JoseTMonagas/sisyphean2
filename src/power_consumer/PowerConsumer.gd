extends Node2D

export var CONSUMPTION_RATE: int

var currentNode: Node2D = null
var groundNode: Node2D = null

onready var currentArea: Area2D = $Current
onready var groundArea: Area2D = $Ground

func _ready() -> void:
	assert(CONSUMPTION_RATE > 0)


func _on_Current_area_entered(area: Area2D) -> void:
	currentNode = area.get_parent()


func _on_Current_area_exited(area: Area2D) -> void:
	if area.get_parent() == currentNode:
		currentNode = null


func _on_Ground_area_entered(area: Area2D) -> void:
	groundNode = area.get_parent()


func _on_Ground_area_exited(area: Area2D) -> void:
	if area.get_parent() == groundNode:
		groundNode = null
