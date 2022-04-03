extends Button

onready var sfx = $ButtonHover

func _on_Start_focus_entered():
	sfx.pitch_scale = 2
	sfx.play()


func _on_Start_mouse_entered():
	sfx.pitch_scale = 1
	$ButtonHover.play()
