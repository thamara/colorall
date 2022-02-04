extends Control
tool

export var text = "Credits"

signal pressed


func _ready():
	$Label.text = text


func _on_TextureButton_pressed():
	$AudioStreamPlayer.play()


func _on_AudioStreamPlayer_finished():
	emit_signal("pressed")
