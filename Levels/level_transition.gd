extends CanvasLayer

@onready var animation_player = $AnimationPlayer
@onready var level_completed_time_label = $CenterContainer/VBoxContainer/LevelCompletedTimeLabel
@onready var center_container = $CenterContainer
@onready var h_box_container = %HBoxContainer
@onready var retry_button = %RetryButton
@onready var next_level_button = %NextLevelButton

signal next_level
signal retry_level


func fade_from_black():
	animation_player.play("fade_from_black")
	await animation_player.animation_finished


func fade_to_black():
	animation_player.play("fade_to_black")
	await animation_player.animation_finished


func show_level_completed_label():
	await get_tree().create_timer(0.6).timeout
	center_container.show()
	await get_tree().create_timer(1.2).timeout
	h_box_container.visibility_layer = 1


func in_between_level_transition():
	center_container.hide()
	h_box_container.visibility_layer = 0
	await get_tree().create_timer(0.6).timeout


func _on_retry_button_pressed():
	in_between_level_transition()
	LevelTransition.retry_level.emit()


func _on_next_level_buton_pressed():
	in_between_level_transition()
	LevelTransition.next_level.emit()
