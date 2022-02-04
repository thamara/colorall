extends Control

export (PackedScene) var scene

signal pressed


func _on_BackBtn_pressed():
	$BackBtnAudio.play()


func _on_BackBtnAudio_finished():
	if !scene:
		get_tree().change_scene("res://LevelSelection.tscn")
		get_parent().get_parent().queue_free()
	else:
		get_tree().change_scene_to(scene)
		get_parent().queue_free()
