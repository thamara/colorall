extends Node2D

# Algorithms by Chad Crouch
# Space by Chad Crouch

export (int) var time = 60
export (int) var grid_id = 1
export (int) var width = 12
export (int) var height = 9
export (float) var grid_scale = 1.5
export (float) var click_cooldown = 1
export (bool) var tutorial = false

onready var timer = $Timer
onready var show_go_timer = $ShowGoTimer
onready var click_timer = $ClickTimer
onready var timer_bar = $HUD/TimerBar
onready var timer_label = $HUD/TimerLabel
onready var score_label = $HUD/ScoreLabel
onready var penalty_label = $HUD/PenaltyLabel
onready var final_score = $HUD/FinalScore
onready var final_score_box = $HUD/HighestScore
onready var final_score_win = $HUD/HighestScore/Box/Current/Score/Value
onready var highest_score_win = $HUD/HighestScore/Box/Best/Score/Value
onready var final_clicks_win = $HUD/HighestScore/Box/Current/Clicks/Value
onready var highest_clicks_win = $HUD/HighestScore/Box/Best/Clicks/Value
onready var start_btn = $HUD/StartBtn
onready var click_progress_bar = $HUD/ClickProgressBar
onready var grid = $GridControl/Grid
onready var grid_control = $GridControl
onready var bg_geometric = $BgGeometric

onready var tutorial_node = $Tutorial
onready var tutorial_steps = [
	$Tutorial/S1,
	$Tutorial/S2,
	$Tutorial/S3,
	$Tutorial/S4,
	$Tutorial/S5,
	$Tutorial/S6,
	$Tutorial/S7,
	$Tutorial/S8,
]
var tutorial_step = 0

var re_use_grid = tutorial

func initialize_game():
	timer_bar.value = time
	timer_bar.max_value = time
	timer.wait_time = time
	timer_label.text = _get_time_str(time)


func _ready():
	grid.width = width
	grid.height = height
	grid_control.rect_scale = Vector2(grid_scale, grid_scale)
	grid_control.rect_size = Vector2(648, 504)
	click_timer.wait_time = click_cooldown
	if !tutorial:
		remove_child(tutorial_node)
	else:
		grid.new_game()
		tutorial_node.visible = true
		re_use_grid = true
	initialize_game()

	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property($HUD/ToolTip/Sprite, "modulate", $HUD/ToolTip/Sprite.modulate, Color(1, 1, 1, 1), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.set_repeat(true)
	tween.start()


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
			$Tween.interpolate_property(click_progress_bar, "value", 0, 100, click_cooldown)
			$Tween.start()
		$HUD/ToolTip.visible = false


func process_game_over():
	var crown = $HUD/HighestScore/Crown
	crown.visible = false
	var is_new_best = GameManager.save_highscore(grid_id, GameManager.final_score, GameManager.click_count)
	final_score_win.text = str(GameManager.final_score)
	highest_score_win.text = str(GameManager.get_highscore(grid_id))
	final_clicks_win.text = str(GameManager.click_count)
	highest_clicks_win.text = GameManager.get_click_count_str(grid_id)
	crown.visible = is_new_best
	final_score_box.visible = true


func _on_Grid_game_over():
	var time_left = timer.time_left
	timer.stop()
	GameManager.report_game_over(grid_id, time_left)
	GameManager.report_first_and_last_colors(grid_id, grid.starting_color, grid.last_color)
	show_go_timer.start()
	$ProgressBarColor.stop_all()
	timer_bar.visible = false;
	process_game_over()


func _on_Area2D_input_event(viewport, event, shape_idx):
	if tutorial:
		return
	if (event is InputEventMouseButton && event.pressed):
		start_btn.visible = false
		$Select.play()
		final_score_box.visible = false
		if !re_use_grid:
			grid.new_game()
		timer.start()
		timer_bar.visible = true;
		$ProgressBarColor.interpolate_property(timer_bar, "modulate", Color("#6dcb93"), Color("#f03c37"), 60)
		$ProgressBarColor.start()
		score_label.text = str(GameManager.score)
		penalty_label.text = str(GameManager.click_count)


func _on_ShowGoTimer_timeout():
	start_btn.visible = true


func _on_ClickTimer_timeout():
	GameManager.state = GameManager.State.Ready


func _on_Skip_pressed():
	tutorial = false
	tutorial_node.visible = false


func _on_Next_pressed():
	if tutorial_step == 3:
		timer_bar.visible = true
	if tutorial_step == 6:
		tutorial_node.get_node("Next").text = "Done"
	if tutorial_step == 7:
		tutorial = false
		tutorial_node.visible = false
		return
		
	tutorial_steps[tutorial_step].visible = false
	tutorial_step += 1
	tutorial_steps[tutorial_step].visible = true
	
