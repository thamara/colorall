extends Control
tool

export (int) var grid = 0 setget set_grid
export (bool) var active = false setget set_active


func _ready():
	match grid:
		0: $Label.text = "Easy"
		1: $Label.text = "Med."
		2: $Label.text = "Hard"
	$Active.visible = active
	$Inactive.visible = !active


func set_grid(new_value):
	grid = new_value
	if $Label:
		match grid:
			0: $Label.text = "Easy"
			1: $Label.text = "Med."
			2: $Label.text = "Hard"

func set_active(new_value):
	active = new_value
	if $Active and $Inactive:
		$Active.visible = active
		$Inactive.visible = !active
