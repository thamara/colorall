extends Control
tool

export var text = "Credits" setget set_text

signal pressed


func _ready():
	$Label.text = text

func set_text(value):
	text = value
	if $Label:
		$Label.text = text

func _on_TextureButton_pressed():
	$AudioStreamPlayer.play()


func _on_AudioStreamPlayer_finished():
	emit_signal("pressed")
