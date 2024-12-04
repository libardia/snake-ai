extends VBoxContainer


@onready var game_result: Label = $GameResult
@onready var button: Button = $Restart


func _lose() -> void:
	visible = true
	button.grab_focus()
	game_result.text = 'Game Over'
