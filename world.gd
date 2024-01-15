extends Node2D

@export var next_level : PackedScene

var level_time = 0.0
var start_level_msec = 0.0

@onready var start_in = %StartIn
@onready var start_in_label = %StartInLabel
@onready var animation_player = $AnimationPlayer
@onready var level_time_label = %LevelTimeLabel


func _input(event):
	if Input.is_action_just_pressed("retry_level"):
		await LevelTransition.fade_to_black()
		get_tree().reload_current_scene()


func _ready():
	if not next_level:
		LevelTransition.next_level_button.text = "Victory"
	else:
		LevelTransition.next_level_button.text = "Next Level"
	
	Events.level_completed.connect(show_level_completed)
	LevelTransition.next_level.connect(go_to_next_level)
	LevelTransition.retry_level.connect(retry_level)
	
	get_tree().paused = true
	start_in.show()
	LevelTransition.fade_from_black()
	animation_player.play("countdown")
	await animation_player.animation_finished
	get_tree().paused = false
	start_in.hide()
	start_level_msec = Time.get_ticks_msec()


func _process(_delta):
	level_time = Time.get_ticks_msec() - start_level_msec
	level_time_label.text = str(level_time / 1000.0)


func go_to_next_level():
	if not next_level:
		get_tree().change_scene_to_file("res://UI/VictoryScreen.tscn")
		return
	
	get_tree().paused = false
	get_tree().change_scene_to_packed(next_level)


func retry_level():
	get_tree().paused = false 
	get_tree().reload_current_scene()
	
	
func show_level_completed():
	get_tree().paused = true
	await get_tree().create_timer(0.25).timeout
	await LevelTransition.fade_to_black()
	LevelTransition.level_completed_time_label.text = "Time: " + level_time_label.text
	await LevelTransition.show_level_completed_label()
	LevelTransition.next_level_button.grab_focus()
