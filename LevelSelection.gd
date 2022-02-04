extends Node2D


onready var score_easy = $Box/EasyBox/Score
onready var medium_easy = $Box/MediumBox/Score
onready var hard_easy = $Box/HardBox/Score

func _ready():
	score_easy.text = str(GameManager.get_highscore(0))
	medium_easy.text = str(GameManager.get_highscore(1))
	hard_easy.text = str(GameManager.get_highscore(2))


func _on_Btn_pressed(extra_arg):
	var game = preload("res://Game.tscn").instance()

	# easy
	if extra_arg == 0:
		game.time = 60
		game.grid_id = 0
		game.width = 5
		game.height = 5
		game.grid_scale = 2.5
	# medium
	elif extra_arg == 1:
		game.time = 60
		game.grid_id = 1
		game.width = 12
		game.height = 9
		game.grid_scale = 1.5
	# hard
	elif extra_arg == 2:
		game.time = 60
		game.grid_id = 2
		game.width = 14
		game.height = 11
		game.grid_scale = 1.2
		game.click_cooldown = 0.5

	get_tree().get_root().add_child(game)
	queue_free()


func _on_BackBtn_pressed():
	get_tree().change_scene("res://Menu.tscn")
