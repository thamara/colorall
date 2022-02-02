extends Node2D

signal color_clicked

func _ready():
	pass # Replace with function body.


func _on_Color_input_event(viewport, event, shape_idx, extra_arg):
	if (event is InputEventMouseButton && event.pressed):
		GameManager.set_color(extra_arg)
		emit_signal("color_clicked")
		print("Clicked ", extra_arg)

