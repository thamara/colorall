extends Node2D


onready var tutorial_score = $Box/TutorialBox/Score
onready var easy_score = $Box/EasyBox/Score
onready var medium_score = $Box/MediumBox/Score
onready var hard_score = $Box/HardBox/Score

onready var tutorial_clicks = $Box/TutorialBox/Clicks
onready var easy_clicks = $Box/EasyBox/Clicks
onready var medium_clicks = $Box/MediumBox/Clicks
onready var hard_clicks = $Box/HardBox/Clicks

onready var game_scene = preload("res://Game.tscn")

func _ready():
	tutorial_score.text = str(GameManager.get_highscore(-1))
	easy_score.text = str(GameManager.get_highscore(0))
	medium_score.text = str(GameManager.get_highscore(1))
	hard_score.text = str(GameManager.get_highscore(2))
	
	tutorial_clicks.text = GameManager.get_click_count_str(-1)
	easy_clicks.text = GameManager.get_click_count_str(0)
	medium_clicks.text = GameManager.get_click_count_str(1)
	hard_clicks.text = GameManager.get_click_count_str(2)
	


func _on_Btn_pressed(extra_arg):
	var game = game_scene.instance()

	# tutorial
	if extra_arg == -1:
		game.time = 60
		game.grid_id = -1
		game.width = 5
		game.height = 5
		game.grid_scale = 2
		game.tutorial = true
	# easy
	if extra_arg == 0:
		game.time = 60
		game.grid_id = 0
		game.width = 7
		game.height = 7
		game.grid_scale = 1.8
		game.tutorial = false
	# medium
	elif extra_arg == 1:
		game.time = 60
		game.grid_id = 1
		game.width = 12
		game.height = 9
		game.grid_scale = 1.5
		game.tutorial = false
	# hard
	elif extra_arg == 2:
		game.time = 60
		game.grid_id = 2
		game.width = 14
		game.height = 11
		game.grid_scale = 1.2
		game.click_cooldown = 0.5
		game.tutorial = false

	get_tree().get_root().add_child(game)
	queue_free()


func _on_AchievementsBtn_pressed():
	$BackBtnAudio.play()


func _on_BackBtnAudio_finished():
	get_tree().change_scene("res://AchievementsScreen.tscn")
	queue_free()
