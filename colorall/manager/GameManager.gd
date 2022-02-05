extends Node

enum Achievements { SoClose = 0, FullCycle, BeatTheDev, SavingMuch, TenXEveryWhere }
const achievements_template = {
	Achievements.SoClose: { 
		"name": "Soooo close!", 
		"description": "Complete a level with less than 1 second remaining.",
		"achieved": {0: false, 1: false, 2: false}
	},
	Achievements.FullCycle: { 
		"name": "Full cycle", 
		"description": "Complete a level where the last color is the same as the color of your starting blob.",
		"achieved": {0: false, 1: false, 2: false}
	},
	Achievements.BeatTheDev: { 
		"name": "Beat the Dev", 
		"description": "Get a score higher than the developer of the game (Easy: 1370, Medium: 2411, Hard: 2532).",
		"achieved": {0: false, 1: false, 2: false}
	},
	Achievements.SavingMuch: { 
		"name": "Saving much?!", 
		"description": "Complete a level using at least one color only up to one time.",
		"achieved": {0: false, 1: false, 2: false}
	},
	Achievements.TenXEveryWhere: { 
		"name": "10x everywhere!", 
		"description": "Play a level at leat 10 times. Winning is good, but playing is what counts.",
		"achieved": {0: false, 1: false, 2: false}
	},
}

const score_template = {
	-1: {"score": 0, "clicks": -1, "num_times": 0},
	0: {"score": 0, "clicks": -1, "num_times": 0},
	1: {"score": 0, "clicks": -1, "num_times": 0},
	2: {"score": 0, "clicks": -1, "num_times": 0},
}

var user_achievements = achievements_template

func get_achievement(id):
	match id:
		0: return user_achievements[Achievements.SoClose]
		1: return user_achievements[Achievements.FullCycle]
		2: return user_achievements[Achievements.BeatTheDev]
		3: return user_achievements[Achievements.SavingMuch]
		4: return user_achievements[Achievements.TenXEveryWhere]


const SAVE_FILE_PATH = "user://savedata.save"
const ACHIEVEMENTS_FILE_PATH = "user://achievements.save"
const AUDIO_FILE_PATH = "user://audio_level.save"

enum Colors { Black = 0, White, Red, Yellow, Blue, Purple, Green, Orange}
enum State { Wait, Ready }


var color_selected = Colors.Black
var score = 0
var final_score = 0
var best_score = score_template
var click_count = 0
var audio_volume = 1 setget set_audio_volume
var state = State.Wait
var achievement_notifier = null


const EnumToName = {
	Colors.Black: "Black",
	Colors.White: "White",
	Colors.Red: "Red",
	Colors.Yellow: "Yellow",
	Colors.Blue: "Blue",
	Colors.Purple: "Purple",
	Colors.Green: "Green",
	Colors.Orange: "Orange",
}

const ColorNameToEnum = {
	"Black": Colors.Black,
	"White": Colors.White,
	"Red": Colors.Red,
	"Yellow": Colors.Yellow,
	"Blue": Colors.Blue,
	"Purple": Colors.Purple,
	"Green": Colors.Green,
	"Orange": Colors.Orange,
}

const tiles = [
	["Black", preload("res://tiles/Black.tscn")],
	["White", preload("res://tiles/White.tscn")],
	["Red", preload("res://tiles/Red.tscn")],
	["Yellow", preload("res://tiles/Yellow.tscn")],
	["Blue", preload("res://tiles/Blue.tscn")],
	["Purple", preload("res://tiles/Purple.tscn")],
	["Green", preload("res://tiles/Green.tscn")],
	["Orange", preload("res://tiles/Orange.tscn")],
]

signal counter_changed



func get_highscore(grid_id):
	if grid_id in best_score:
		if "score" in best_score[grid_id]:
			return best_score[grid_id]["score"]
	return 0


func get_click_count_str(grid_id):
	if grid_id in best_score:
		if "clicks" in best_score[grid_id]:
			var clicks = best_score[grid_id]["clicks"]
			if clicks == -1:
				return "-"
			return str(best_score[grid_id]["clicks"])
	return "-"


func save_best_score():
	var save_data = File.new()
	save_data.open(SAVE_FILE_PATH, File.WRITE)
	save_data.store_var(best_score)
	save_data.close()


func save_highscore(grid_id, value, clicks):
	report_highscore(grid_id, value)
	var new_highscore = false
	if !(grid_id in best_score):
		best_score[grid_id] = {"score": 0, "clicks": -1, "num_times": 0}
	if best_score[grid_id]["score"] < value:
		best_score[grid_id]["score"] = value
		new_highscore = true
	if best_score[grid_id]["clicks"] > clicks || best_score[grid_id]["clicks"] == -1:
		best_score[grid_id]["clicks"] = clicks

	save_best_score()
	
	return new_highscore


func load_highscore():
	var save_data = File.new()
	if save_data.file_exists(SAVE_FILE_PATH):
		save_data.open(SAVE_FILE_PATH, File.READ)
		best_score = save_data.get_var()
		save_data.close()
	else:
		best_score = score_template
		save_best_score()


func number_to_color(n):
	var n_to_c = {
		0: Colors.Black,
		1: Colors.White,
		2: Colors.Red,
		3: Colors.Yellow,
		4: Colors.Blue,
		5: Colors.Purple,
		6: Colors.Green,
		7: Colors.Orange,
	}
	return n_to_c[n]


func set_color(n):
	color_selected = number_to_color(n)


func load_audio_volume():
	var save_data = File.new()
	if save_data.file_exists(AUDIO_FILE_PATH):
		save_data.open(AUDIO_FILE_PATH, File.READ)
		audio_volume = save_data.get_var()
		save_data.close()


func set_audio_volume(volume):
	audio_volume = volume
	var save_data = File.new()
	save_data.open(AUDIO_FILE_PATH, File.WRITE)
	save_data.store_var(audio_volume)
	save_data.close()


func register_achievement_notifier(v):
	achievement_notifier = v


func save_achievements():
	var save_data = File.new()
	save_data.open(ACHIEVEMENTS_FILE_PATH, File.WRITE)
	save_data.store_var(user_achievements)
	save_data.close()


func load_achievements():
	var save_data = File.new()
	if save_data.file_exists(ACHIEVEMENTS_FILE_PATH):
		save_data.open(ACHIEVEMENTS_FILE_PATH, File.READ)
		user_achievements = save_data.get_var()
		save_data.close()
	else:
		user_achievements = achievements_template
		save_achievements()


func report_game_over(grid_id, time_left):
	# Do not count achievements for tutorial
	if grid_id < 0:
		return
		
	# TenXEveryWhere
	if grid_id in best_score:
		if "num_times" in best_score[grid_id]:
			best_score[grid_id]["num_times"] += 1
			save_best_score()
	if !user_achievements[Achievements.TenXEveryWhere]["achieved"][grid_id] && best_score[grid_id]["num_times"] >= 10:
		user_achievements[Achievements.TenXEveryWhere]["achieved"][grid_id] = true
		save_achievements()
		achievement_notifier.push_achievement(user_achievements[Achievements.TenXEveryWhere]["name"])
	# So Close
	if time_left != 0 && time_left <= 1 && !user_achievements[Achievements.SoClose]["achieved"][grid_id]:
		user_achievements[Achievements.SoClose]["achieved"][grid_id] = true
		save_achievements()
		achievement_notifier.push_achievement(user_achievements[Achievements.SoClose]["name"])


func report_first_and_last_colors(grid_id, first, last):
	if grid_id < 0:
		return
	if first != "" && first == last && !user_achievements[Achievements.FullCycle]["achieved"][grid_id]:
		user_achievements[Achievements.FullCycle]["achieved"][grid_id] = true
		save_achievements()
		achievement_notifier.push_achievement(user_achievements[Achievements.FullCycle]["name"])


func report_highscore(grid_id, score):
	if grid_id < 0:
		return
	if !user_achievements[Achievements.BeatTheDev]["achieved"][grid_id]:
		var beat = false
		if grid_id == 0:
			beat = score > 1370
		elif grid_id == 1:
			beat = score > 2411
		elif grid_id == 2:
			beat = score > 2532
		if beat:
			user_achievements[Achievements.BeatTheDev]["achieved"][grid_id] = true
			save_achievements()
			achievement_notifier.push_achievement(user_achievements[Achievements.BeatTheDev]["name"])


func report_color_clicks(grid_id, click_per_color):
	if grid_id < 0:
		return
	if user_achievements[Achievements.SavingMuch]["achieved"][grid_id]:
		return

	var beat = false
	if len(click_per_color) < 8:
		beat = true
	else:
		var colors_clicked_once = []
		for i in click_per_color.keys():
			if click_per_color[i] <= 1:
				colors_clicked_once.append(i)
		beat = len(colors_clicked_once) > 0
	
	if beat:
		user_achievements[Achievements.SavingMuch]["achieved"][grid_id] = true
		save_achievements()
		achievement_notifier.push_achievement(user_achievements[Achievements.SavingMuch]["name"])

func _ready():
	MusicManager.play()
	load_highscore()
	load_audio_volume()
	load_achievements()
