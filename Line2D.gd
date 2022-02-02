extends Line2D

export (Gradient) var grad

var follows = []

onready var path = $Path2D

func _ready():
	for i in 10:
		var new_follow = PathFollow2D.new()
		path.add_child(new_follow)
		new_follow.unit_offset = float(i * 0.02)
		follows.append(new_follow)


func _process(delta):
	clear_points()
	for f in follows:
		f.unit_offset = wrapf(f.unit_offset + delta, 0, 1)
		add_point(f.global_position)
	
	gradient.colors[0] = grad.interpolate(follows[0].unit_offset)
	gradient.colors[1] = grad.interpolate(follows[-1].unit_offset)
