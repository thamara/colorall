extends Node2D

func _ready():
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property($Path2D/PathFollow2D, "unit_offset", 0, 1, 30)
	tween.set_repeat(true)
	tween.start()
