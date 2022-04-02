extends Node2D

var currentNode: Node2D = null

onready var currentArea: Area2D = $Current


func _on_Current_area_entered(area: Area2D) -> void:
	currentNode = area.get_parent()


func _on_Current_area_exited(area: Area2D) -> void:
	if area.get_parent() == currentNode:
		currentNode = null
