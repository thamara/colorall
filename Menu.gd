extends Node2D


signal timer_end

func _emit_timer_end_signal():
	emit_signal("timer_end")


func _create_timer():
	var timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_timer_process_mode(0)
	timer.set_wait_time(0.2)
	timer.connect("timeout", self, "_emit_timer_end_signal")
	add_child(timer)
	timer.start()


func _ready():
	pass # Replace with function body.


func _on_Animation1_timeout():
	print(' animation 1 timeout')
	
	$Tween.interpolate_property($Mouse, "position", $Mouse.position, Vector2(924, 234), 0.2)
	$Tween.start()
	
	_create_timer()
	yield(self,"timer_end")
	
	$Mouse.click()
	_create_timer()
	yield(self,"timer_end")
	
	$TileMap/Tile00.set_color("Black")
	_create_timer()
	yield(self,"timer_end")
	
	$TileMap/Tile10.set_color("Black")
	_create_timer()
	yield(self,"timer_end")
	
	$TileMap/Tile20.show_glow()
	_create_timer()
	yield(self,"timer_end")
	
	$TileMap/Tile01.set_color("Black")
	_create_timer()
	yield(self,"timer_end")
	
	$TileMap/Tile02.set_color("Black")
	_create_timer()
	yield(self,"timer_end")
	
	$TileMap/Tile12.set_color("Black")
	_create_timer()
	yield(self,"timer_end")
	
	$TileMap/Tile13.show_glow()
	_create_timer()
	yield(self,"timer_end")
	
	$TileMap/Tile23.show_glow()
	_create_timer()
	yield(self,"timer_end")
	
	$Tween.interpolate_property($Mouse, "position", $Mouse.position, Vector2(936, 324), 0.2)
	$Tween.start()
	
	_create_timer()
	yield(self,"timer_end")
	
	$Mouse.click()
	_create_timer()
	yield(self,"timer_end")
	
	$TileMap/Tile00.set_color("Yellow")
	_create_timer()
	yield(self,"timer_end")
	
	$TileMap/Tile10.set_color("Yellow")
	_create_timer()
	yield(self,"timer_end")
	
	$TileMap/Tile20.set_color("Yellow")
	_create_timer()
	yield(self,"timer_end")
	
	$TileMap/Tile01.set_color("Yellow")
	_create_timer()
	yield(self,"timer_end")
	
	$TileMap/Tile11.show_glow()
	_create_timer()
	yield(self,"timer_end")
	
	$TileMap/Tile21.show_glow()
	_create_timer()
	yield(self,"timer_end")
	
	$TileMap/Tile02.set_color("Yellow")
	_create_timer()
	yield(self,"timer_end")
	
	$TileMap/Tile12.set_color("Yellow")
	_create_timer()
	yield(self,"timer_end")
	
	$TileMap/Tile22.show_glow()
	_create_timer()
	yield(self,"timer_end")
	
	$TileMap/Tile03.show_glow()
	_create_timer()
	yield(self,"timer_end")
	
	$TileMap/Tile13.set_color("Yellow")
	_create_timer()
	yield(self,"timer_end")
	
	$TileMap/Tile23.set_color("Yellow")
	_create_timer()
	yield(self,"timer_end")
	
	$Tween.interpolate_property($Mouse, "position", $Mouse.position, Vector2(1062, 324), 0.2)
	$Tween.start()
	


func _on_AnimationSetup_timeout():
	$Tween.interpolate_property($Mouse, "position", $Mouse.position, Vector2(1062, 324), 0.2)
