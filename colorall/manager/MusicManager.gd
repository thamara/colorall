extends Node2D

var musics = [
	load("res://assets/Chad Crouch - Space.mp3"),
	load("res://assets/Chad Crouch - Algorithms.mp3"),
]

var music_id = 0

func _ready():
	$Music.stream = musics[music_id]
	music_id += 1


func play():
	$Music.play()


func _on_Music_finished():
	if music_id <  len(musics):
		music_id = 0
	$Music.stream = musics[music_id]
	$Music.play()
