extends Node2D

# Algorithms by Chad Crouch
# Space by Chad Crouch

export (int) var time = 60
export (int) var level = 1

onready var timer = $Timer
onready var show_go_timer = $ShowGoTimer
onready var click_timer = $ClickTimer
onready var timer_bar = $HUD/TimerBar
onready var timer_label = $HUD/TimerLabel
onready var score_label = $HUD/ScoreLabel
onready var penalty_label = $HUD/PenaltyLabel
onready var final_score = $HUD/FinalScore
onready var final_score_box = $HUD/HighestScore
onready var final_score_win = $HUD/HighestScore/FinalScore
onready var highest_score_win = $HUD/HighestScore/HighestScore
onready var start_btn = $HUD/StartBtn
onready var click_progress_bar = $HUD/ClickProgressBar
onready var grid = $Grid
onready var bg_geometric = $BgGeometric


func initialize_game():
	timer_bar.value = time
	timer_bar.max_value = time
	timer.wait_time = time
	timer_label.text = _get_time_str(time)


func _ready():
	initialize_game()


func _get_time_str(time_in_secs):
	var mils = fmod(time_in_secs, 1)*10
	var secs = fmod(time_in_secs, 60)
	var mins = fmod(time_in_secs, 60*60) / 60
	return "%02d:%02d.%1d" % [mins, secs, mils]


func update_score():
	var time_left = timer.time_left
	timer_bar.value = time_left
	timer_label.text = _get_time_str(time_left)
	GameManager.final_score = floor((GameManager.score - GameManager.click_count) * max(time_left, 1))
	final_score.text = str(GameManager.final_score)


func _process(_delta):
	if !timer.is_stopped():
		update_score()


func _on_Timer_timeout():
	grid.stop_game()	
	show_go_timer.start()


func _on_ColorSelection_color_clicked():
	if !timer.is_stopped():
		grid.run_game()
		score_label.text = str(GameManager.score)
		penalty_label.text = str(GameManager.click_count)
		if click_timer.is_stopped():
			click_timer.start()
			$Tween.interpolate_property(click_progress_bar, "value", 0, 100, 1)
			$Tween.start()


func _on_Grid_game_over():
	timer.stop()
	show_go_timer.start()
	$ProgressBarColor.stop_all()
	final_score_win.text = str(GameManager.final_score)
	highest_score_win.text = str(GameManager.score)
	final_score_box.visible = true


func _on_Area2D_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		start_btn.visible = false
		$Select.play()
		final_score_box.visible = false
		grid.new_game()
		timer.start()
		$ProgressBarColor.interpolate_property(timer_bar, "modulate", Color("#6dcb93"), Color("#f03c37"), 60)
		$ProgressBarColor.start()
		score_label.text = str(GameManager.score)
		penalty_label.text = str(GameManager.click_count)


func _on_ShowGoTimer_timeout():
	start_btn.visible = true


func _on_ClickTimer_timeout():
	GameManager.state = GameManager.State.Ready


func _on_BackBtn_pressed():
	get_tree().change_scene("res://Menu.tscn")
