extends Container

export (String, "Black", "White", "Red", "Yellow", "Blue", "Purple", "Green", "Orange") var color_name = "Black"
export (int) var value = 0

onready var color = $Node2D/Color
onready var amount = $Node2D/Color/HBoxContainer/Amount
onready var storage = $Node2D/Color/HBoxContainer/Storage

func _ready():
	set_color(color_name)
	set_value(value)
	_update_storage()
	GameManager.connect("counter_changed", self, "_update_storage")


func _update_storage():
	storage.text = str(GameManager.cnt[GameManager.ColorNameToEnum[color_name]])


func set_color(c):
	color_name = c
	if color:
		color.set_color(color_name)


func set_value(val):
	value = val
	if amount:
		amount.text = str(value)
