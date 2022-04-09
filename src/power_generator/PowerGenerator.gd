extends Node2D

var currentNode: Node2D = null

onready var currentArea: Area2D = $Current


func _on_Current_area_entered(area: Area2D) -> void:
	print(area.get_parent())
	currentNode = area.get_parent()


func set_anim(anim):
	if anim == 'run':
		$AnimationPlayer.play("running")
	elif anim == 'stop':
		$AnimationPlayer.play("stop")
