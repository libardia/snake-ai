extends Node2D


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		event = event as InputEventKey
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()
