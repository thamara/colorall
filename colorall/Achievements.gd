extends Control

var achievement = preload("res://Achievement.tscn")
var queue = []
onready var box = $Control/Box

func _input(event):
	if Input.is_action_just_pressed("a"):
		push_achievement("test")


func push_achievement(text):
	var new_item = achievement.instance()
	new_item.achievement_name = text
	queue.push_back(new_item)


func _process(_delta):
	if len(queue) && len(box.get_children()) == 0:
		var new_item = queue.pop_front()
		box.add_child(new_item)


func _ready():
	GameManager.register_achievement_notifier(self)

