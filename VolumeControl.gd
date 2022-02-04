extends Control

export var audio_bus_name = "Master"
onready var bus := AudioServer.get_bus_index(audio_bus_name)
onready var volume_control = $Volume

func _ready():
	volume_control.visible = false
	AudioServer.set_bus_volume_db(bus, linear2db(GameManager.audio_volume))
	volume_control.value = GameManager.audio_volume


func _on_TextureButton_pressed():
	volume_control.visible = !volume_control.visible


func _on_Volume_value_changed(value):
	GameManager.audio_volume = value
	AudioServer.set_bus_volume_db(bus, linear2db(GameManager.audio_volume))
