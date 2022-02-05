extends Node2D

export (bool) var dummy = false

signal color_clicked


func refresh_texture():
	if GameManager.use_symbols:
		$Colors8/Circle.texture = preload("res://assets/circle_8_symbols.png")
	else:
		$Colors8/Circle.texture = preload("res://assets/circle_8.png")



func _ready():
	refresh_texture()


func _on_Color_input_event(viewport, event, shape_idx, extra_arg):
	if (event is InputEventMouseButton && event.pressed) and !dummy:
		GameManager.set_color(extra_arg)
		emit_signal("color_clicked")

