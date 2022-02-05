extends Node

enum Achievements { SoClose = 0, FullCycle }
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
}

const IdToAchievement = {
	0: Achievements.SoClose,
	1: Achievements.FullCycle,
}

var user_achievements = achievements_template

func get_achievement(id):
	match id:
		0: return user_achievements[Achievements.SoClose]
		1: return user_achievements[Achievements.FullCycle]


const SAVE_FILE_PATH = "user://savedata_v2.save"
const ACHIEVEMENTS_FILE_PATH = "user://achievements.save"
const AUDIO_FILE_PATH = "user://audio_level.save"

enum Colors { Black = 0, White, Red, Yellow, Blue, Purple, Green, Orange}
enum State { Wait, Ready }


var color_selected = Colors.Black
var score = 0
var final_score = 0
var best_score = {}
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


func save_highscore(grid_id, value, clicks):
	var new_highscore = false
	if !(grid_id in best_score):
		best_score[grid_id] = {"score": 0, "clicks": -1}
	if best_score[grid_id]["score"] < value:
		best_score[grid_id]["score"] = value
		new_highscore = true
	if best_score[grid_id]["clicks"] > clicks || best_score[grid_id]["clicks"] == -1:
		best_score[grid_id]["clicks"] = clicks

	var save_data = File.new()
	save_data.open(SAVE_FILE_PATH, File.WRITE)
	save_data.store_var(best_score)
	save_data.close()
	
	return new_highscore


func load_highscore():
	var save_data = File.new()
	if save_data.file_exists(SAVE_FILE_PATH):
		save_data.open(SAVE_FILE_PATH, File.READ)
		best_score = save_data.get_var()
		save_data.close()
	if !best_score:
		best_score = {"score": 0, "clicks": -1}


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
	# So Close
	if time_left <= 1 && !user_achievements[Achievements.SoClose]["achieved"][grid_id]:
		user_achievements[Achievements.SoClose]["achieved"][grid_id] = true
		save_achievements()
		achievement_notifier.push_achievement(user_achievements[Achievements.SoClose]["name"])


func report_first_and_last_colors(grid_id, first, last):
	if first != "" && first == last && !user_achievements[Achievements.FullCycle]["achieved"][grid_id]:
		user_achievements[Achievements.FullCycle]["achieved"][grid_id] = true
		save_achievements()
		achievement_notifier.push_achievement(user_achievements[Achievements.FullCycle]["name"])
	


func _ready():
	MusicManager.play()
	load_highscore()
	load_audio_volume()
	load_achievements()
