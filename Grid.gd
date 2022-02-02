extends Node2D

# music: https://opengameart.org/content/crystal-cave-song18

enum State { Wait, Ready }

const time = 60
const width = 26
const height = 13
const offset_w = 1
const offset_h = 1
var all_pieces = []
var state = State.Ready

var first_touch = Vector2()
var last_touch = Vector2()
var moving = false

onready var map = $TileMap
onready var destroy_timer = $DestroyTimer
onready var collapse_timer = $CollapseTimer
onready var refill_timer = $RefillTimer
onready var right_music = $Right
onready var wrong_music = $Wrong
onready var order = $Order

func place_pieces():
	for i in width:
		for j in height:
			create_piece_at(i, j)
	state = State.Ready
	$GameTimer.start()

func initialize_game():
	$UI/TimerBar.value = time
	$UI/TimerBar.max_value = time
	$GameTimer.wait_time = time

	for i in len(all_pieces):
		for j in len(all_pieces[i]):
			if all_pieces[i][j]:
				all_pieces[i][j].queue_free()
				all_pieces[i][j] = null

	all_pieces = make_2d_array(width, height)

func _ready():
#	randomize()
	initialize_game()
	place_pieces()


func make_2d_array(w, h):
	var array = []
	for i in w:
		array.append([])
		for j in h:
			array[i].append([])
	return array


func grid_to_world(i, j):
	var cell_size = map.cell_size.x
	return map.map_to_world(Vector2(offset_w + i, offset_h + j)) + Vector2(cell_size/2, cell_size/2)


func create_piece_at(i, j):
	if all_pieces[i][j]:
		return
	var rand_tile = GameManager.tiles[floor(rand_range(0, len(GameManager.tiles)))]
	var new_tile = rand_tile[1].instance()
	add_child(new_tile)
	new_tile.position = grid_to_world(i, -1)
	new_tile.move(grid_to_world(i, j))
	all_pieces[i][j] = new_tile


func is_a_match(p1, p2, p3):
	return p1 && p2 && p3 && p1.color_name == p2.color_name && p2.color_name == p3.color_name 


func _is_a_match(p1, p2):
	return p1 && p2 && p1.color_name == p2.color_name 


func count_match(p1, p2 , p3):
	var color = p1.color_name
	if !p1.matched:
		GameManager.incr_color_cnt(color)
	if !p2.matched:
		GameManager.incr_color_cnt(color)
	if !p3.matched:
		GameManager.incr_color_cnt(color)

var pieces_to_color = []

func find_matches(first_touch):
	var matched = false
	var new_color = GameManager.EnumToName[GameManager.color_selected]
	var x = first_touch.x
	var y = first_touch.y
	
	var current_piece = all_pieces[x][y]
	if !current_piece:
		return false
	
	if !pieces_to_color.count(current_piece):
		pieces_to_color.append(current_piece)
	else:
		return false

	# look horizontally
	for i in range(x, width):
		var piece = all_pieces[i][y]
		if _is_a_match(current_piece, piece):
			find_matches(Vector2(i, y))
			pieces_to_color.append(piece)
			if !pieces_to_color.count(piece):
				pieces_to_color.append(piece)	
			right_music.play()
		else:
			break
	for i in range(x, -1, -1):
		var piece = all_pieces[i][y]
		if _is_a_match(current_piece, piece):
			find_matches(Vector2(i, y))
			if !pieces_to_color.count(piece):
				pieces_to_color.append(piece)	
			right_music.play()
		else:
			break

	# look vertically
	for j in range(y, height):
		var piece = all_pieces[x][j]
		if _is_a_match(current_piece, piece):
			find_matches(Vector2(x, j))
			if !pieces_to_color.count(piece):
				pieces_to_color.append(piece)	
			right_music.play()
		else:
			break
	for j in range(y, -1, -1):
		var piece = all_pieces[x][j]
		if _is_a_match(current_piece, piece):
			find_matches(Vector2(x, j))
			if !pieces_to_color.count(piece):
				pieces_to_color.append(piece)	
			right_music.play()
		else:
			break

func _input(_event):
	if Input.is_action_just_pressed('q'):
		GameManager.color_selected = GameManager.Colors.Black
	elif Input.is_action_just_pressed('w'):
		GameManager.color_selected = GameManager.Colors.White
	elif Input.is_action_just_pressed('e'):
		GameManager.color_selected = GameManager.Colors.Red
	elif Input.is_action_just_pressed('r'):
		GameManager.color_selected = GameManager.Colors.Yellow
	elif Input.is_action_just_pressed('a'):
		GameManager.color_selected = GameManager.Colors.Blue
	elif Input.is_action_just_pressed('s'):
		GameManager.color_selected = GameManager.Colors.Purple
	elif Input.is_action_just_pressed('d'):
		GameManager.color_selected = GameManager.Colors.Green
	elif Input.is_action_just_pressed('f'):
		GameManager.color_selected = GameManager.Colors.Orange
#	if Input.is_action_just_pressed('r'):
#		get_tree().reload_current_scene()


func global_mouse_position_to_grid():
	return map.world_to_map(get_global_mouse_position()) - Vector2(offset_w, offset_h)


func is_in_grid(pos):
	return pos.x >= 0 && pos.x < width && pos.y >= 0 && pos.y < height


func touch_input():
	if state != State.Ready:
		return

	if Input.is_action_just_pressed("ui_touch"):
		first_touch = global_mouse_position_to_grid()
		if is_in_grid(first_touch):
			find_matches(first_touch)
			for piece in pieces_to_color:
				piece.set_color(GameManager.EnumToName[GameManager.color_selected])
			pieces_to_color = []
			
func can_swap(pos1, pos2):
	var dif = pos1 - pos2
	return (abs(dif.x) + abs(dif.y)) <= 1


func _process(_delta):
	touch_input()
	if !$GameTimer.paused:
		$UI/TimerBar.value = $GameTimer.time_left



func _on_DestroyTimer_timeout():
	pass


func _on_CollapseTimer_timeout():
	pass


func _on_RefillTimer_timeout():
	pass


func _on_NewGame_pressed():
	initialize_game()
	place_pieces()


func _on_GameTimer_timeout():
	# game over
	state = State.Wait
	


func _on_Black_pressed():
	GameManager.color_selected = GameManager.Colors.Black


func _on_White_pressed():
	GameManager.color_selected = GameManager.Colors.White
	pass # Replace with function body.


func _on_Red_pressed():
	GameManager.color_selected = GameManager.Colors.Red
	pass # Replace with function body.


func _on_Yellow_pressed():
	GameManager.color_selected = GameManager.Colors.Yellow
	pass # Replace with function body.


func _on_Blue_pressed():
	GameManager.color_selected = GameManager.Colors.Blue
	pass # Replace with function body.


func _on_Purple_pressed():
	GameManager.color_selected = GameManager.Colors.Purple
	pass # Replace with function body.


func _on_Green_pressed():
	GameManager.color_selected = GameManager.Colors.Green
	pass # Replace with function body.


func _on_Orange_pressed():
	GameManager.color_selected = GameManager.Colors.Orange
	pass # Replace with function body.
