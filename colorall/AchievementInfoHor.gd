extends Control
tool

export (int) var ach_id = 0

onready var ach_name = $BoxInfo/Name
onready var ach_desc = $BoxInfo/Desc
onready var easy = $HBoxContainer/Easy
onready var med = $HBoxContainer/Medium
onready var hard = $HBoxContainer/Hard

# Example
#Achievements.FullCycle: { 
#	"name": "Full cycle", 
#	"description": "Complete a level where the last color is the same as the color of your starting blob.",
#	"achieved": {0: false, 1: false, 2: false}


func _ready():
	var ach_info = GameManager.get_achievement(ach_id)
	ach_name.text = ach_info["name"]
	ach_desc.text = ach_info["description"]
	easy.set_active(ach_info["achieved"][0])
	med.set_active(ach_info["achieved"][1])
	hard.set_active(ach_info["achieved"][2])

