extends Node2D

export (int) var time = 60

onready var timer = $Timer
onready var timer_bar = $HUD/TimerBar
onready var timer_label = $HUD/TimerLabel
onready var start_btn = $HUD/StartBtn

func initialize_game():
	timer_bar.value = time
	timer_bar.max_value = time
	timer.wait_time = time
	timer_label.text = _get_time_str(time)


func _ready():
	initialize_game()
	pass # Replace with function body.


func _get_time_str(time_in_secs):
	var mils = fmod(time_in_secs, 1)*10
	var secs = fmod(time_in_secs, 60)
	var mins = fmod(time_in_secs, 60*60) / 60
	return "%02d:%02d.%1d" % [mins, secs, mils]


func _process(_delta):
	if !timer.is_stopped():
		var time_left = timer.time_left
		timer_bar.value = time_left
		timer_label.text = _get_time_str(time_left)


func _on_StartBtn_pressed():
	timer.start()


func _on_Timer_timeout():
	print('Game ended')
	pass # Replace with function body.



func _on_Area2D_input_event(viewport, event, shape_idx):
	print('Game _on_Area2D_input_event')
	pass # Replace with function body.
