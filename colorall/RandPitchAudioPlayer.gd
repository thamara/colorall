extends AudioStreamPlayer

var last_pitch = 1.0

func play(from_position: float = 0.0):
	randomize()
	pitch_scale = rand_range(0.7, 1.3)
	while abs(pitch_scale - last_pitch) < 0.1:
		pitch_scale = rand_range(0.7, 1.3)	
	
	last_pitch = pitch_scale
	.play(from_position)
