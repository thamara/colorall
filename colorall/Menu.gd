extends Node2D


onready var tile0 = $TileMap/Tile00
onready var tile1 = $TileMap/Tile01
onready var tile2 = $TileMap/Tile02
onready var tile3 = $TileMap/Tile03
onready var tile4 = $TileMap/Tile10
onready var tile5 = $TileMap/Tile11
onready var tile6 = $TileMap/Tile12
onready var tile7 = $TileMap/Tile13
onready var tile8 = $TileMap/Tile20
onready var tile9 = $TileMap/Tile21
onready var tile10 = $TileMap/Tile22
onready var tile11 = $TileMap/Tile23

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
	$Animation1.start()
	$EnableSymbols.pressed = GameManager.use_symbols


func _on_Animation1_timeout():
	$Tween.interpolate_property($Mouse, "position", $Mouse.position, Vector2(557, 57), 0.2)
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
	
	$TileMap/Tile01.set_color("Black")
	_create_timer()
	yield(self,"timer_end")
	
	$TileMap/Tile02.set_color("Black")
	_create_timer()
	yield(self,"timer_end")
	
	$TileMap/Tile12.set_color("Black")
	_create_timer()
	yield(self,"timer_end")
	
	$TileMap/Tile20.show_glow()
	_create_timer()
	yield(self,"timer_end")
	
	$TileMap/Tile13.show_glow()
	_create_timer()
	yield(self,"timer_end")
	
	$TileMap/Tile23.show_glow()
	_create_timer()
	yield(self,"timer_end")
	
	$Tween.interpolate_property($Mouse, "position", $Mouse.position, Vector2(557, 147), 0.2)
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
	
	$TileMap/Tile02.set_color("Yellow")
	_create_timer()
	yield(self,"timer_end")
	
	$TileMap/Tile12.set_color("Yellow")
	_create_timer()
	yield(self,"timer_end")
	
	$TileMap/Tile13.set_color("Yellow")
	_create_timer()
	yield(self,"timer_end")
	
	$TileMap/Tile23.set_color("Yellow")
	_create_timer()
	yield(self,"timer_end")
	
	$TileMap/Tile11.show_glow()
	_create_timer()
	yield(self,"timer_end")
	
	$TileMap/Tile21.show_glow()
	_create_timer()
	yield(self,"timer_end")
	
	$TileMap/Tile22.show_glow()
	_create_timer()
	yield(self,"timer_end")
	
	$TileMap/Tile03.show_glow()
	_create_timer()
	yield(self,"timer_end")
	
	$Tween.interpolate_property($Mouse, "position", $Mouse.position, Vector2(594, -69), 0.2)
	$Tween.start()
	
	$AnimationSetup.start()



func _on_AnimationSetup_timeout():
	$TileMap.visible = false
	tile0.set_color("Blue")
	tile1.set_color("Blue")
	tile2.set_color("Blue")
	tile3.set_color("Yellow")
	tile4.set_color("Blue")
	tile5.set_color("Yellow")
	tile6.set_color("Blue")
	tile7.set_color("Black")
	tile8.set_color("Black")
	tile9.set_color("Yellow")
	tile10.set_color("Yellow")
	tile11.set_color("Black")
	
	
	tile0.hide_glow()
	tile1.hide_glow()
	tile2.hide_glow()
	tile3.hide_glow()
	tile4.hide_glow()
	tile5.hide_glow()
	tile6.hide_glow()
	tile7.hide_glow()
	tile8.hide_glow()
	tile9.hide_glow()
	tile10.hide_glow()
	tile11.hide_glow()
	
	tile0.show_glow()
	tile1.show_glow()
	tile2.show_glow()
	tile4.show_glow()
	tile6.show_glow()
	
	$TileMap.visible = true
	$Animation1.start()


func _on_Button_pressed():
	get_tree().change_scene("res://LevelSelection.tscn")


func _on_EnableSymbols_toggled(button_pressed):
	GameManager.use_symbols = button_pressed
	print(GameManager.use_symbols)
	for node in $TileMap.get_children():
		node.refresh_texture()
	$ColorSelection.refresh_texture()
