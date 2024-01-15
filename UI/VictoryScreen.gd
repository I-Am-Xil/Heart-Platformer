extends CenterContainer

@onready var button = $VBoxContainer/Button

func _ready():
	await get_tree().create_timer(0.5).timeout
	await LevelTransition.fade_from_black()
	get_tree().paused = false
	button.grab_focus()

func _on_button_pressed():
	await LevelTransition.fade_to_black()
	get_tree().change_scene_to_file("res://UI/StartMenu.tscn")
