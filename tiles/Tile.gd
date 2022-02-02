extends Node2D

export (String, "Black", "White", "Red", "Yellow", "Blue", "Purple", "Green", "Orange") var color_name = "Black"

const colorStrToRegion = {
	"Black": Rect2(0, 0, 64, 64),
	"White": Rect2(64, 0, 64, 64),
	"Red":  Rect2(128, 0, 64, 64),
	"Yellow": Rect2(192, 0, 64, 64),
	"Blue":  Rect2(0, 64, 64, 64),
	"Purple":  Rect2(64, 64, 64, 64),
	"Green":  Rect2(128, 64, 64, 64),
	"Orange":  Rect2(192, 64, 64, 64),
}

onready var sprite = $Sprite
onready var moving_tween = $MovingTween
onready var tween = $Tween

var matched = false

func _ready():
	set_color(color_name)
	tween.interpolate_property($Sprite, "scale", Vector2(0.2, 0.2), Vector2(0.5, 0.5), 0.3)
	tween.start()


func set_color(color):
	color_name = color
	if color_name in colorStrToRegion:
		sprite.region_rect = colorStrToRegion[color_name]
	else:
		print('error on color: ', color_name)


func move(new_pos):
	moving_tween.interpolate_property(self, "position", position, new_pos, 0.2, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	moving_tween.start()


func match():
	matched = true
	sprite.modulate = Color(1, 1, 1, 0.5)

