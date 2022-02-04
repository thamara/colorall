extends Control
tool

export var text = "Credits"

signal pressed


func _ready():
	$Label.text = text


func _on_TextureButton_pressed():
	emit_signal("pressed")
