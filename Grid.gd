extends Node2D

export (int) var width = 0
export (int) var height = 0
export (int) var offset_w = 0
export (int) var offset_h = 0

var all_pieces = []
var pieces_to_color = []

onready var map = $TileMap
onready var right_music = $Right

signal game_over


func place_pieces():
	set_bg()
	for i in width:
		for j in height:
			create_piece_at(i, j)
	GameManager.state = GameManager.State.Ready


func initialize_game():
	for i in len(all_pieces):
		for j in len(all_pieces[i]):
			if all_pieces[i][j]:
				all_pieces[i][j].queue_free()
				all_pieces[i][j] = null
	
	GameManager.score = 1
	GameManager.click_count = 0
	all_pieces = make_2d_array(width, height)


func set_bg():
	for i in width:
		for j in height:
			map.set_cell(i, j, 0)


func _ready():
	map.set_cell(0, 0, -1)
	GameManager.score = 1
	GameManager.click_count = 0
	randomize()
#	initialize_game()
#	place_pieces()
#	set_bg()
	pass


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
	if i == 0 && j == 0:
		new_tile.show_glow()
	add_child(new_tile)
	new_tile.position = grid_to_world(i, j)
	all_pieces[i][j] = new_tile


func is_a_match(p1, p2, p3):
	return p1 && p2 && p3 && p1.color_name == p2.color_name && p2.color_name == p3.color_name 


func _is_a_match(p1, p2):
	return p1 && p2 && p1.color_name == p2.color_name 


func find_matches(pos):
	var new_color = GameManager.EnumToName[GameManager.color_selected]
	var x = pos.x
	var y = pos.y
	
	var current_piece = all_pieces[x][y]
	if !current_piece || pieces_to_color.count(current_piece):
		return false
	
	pieces_to_color.append(current_piece)
	right_music.play()
	current_piece.show_glow()

	# look horizontally
	for i in range(x, width):
		var piece = all_pieces[i][y]
		if _is_a_match(current_piece, piece):
			find_matches(Vector2(i, y))
			if !pieces_to_color.count(piece):
				pieces_to_color.append(piece)	
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
	if Input.is_action_just_pressed('r'):
		get_tree().reload_current_scene()


func world_to_grid(pos):
	return map.world_to_map(pos) - Vector2(offset_w, offset_h)


func match_and_color():
	find_matches(Vector2(0, 0))
	for piece in pieces_to_color:
		piece.set_color(GameManager.EnumToName[GameManager.color_selected])
	pieces_to_color = []
	
	# Update Score
	find_matches(Vector2(0, 0))
	var score = len(pieces_to_color)
	GameManager.score = score
	pieces_to_color = []

func run_game():
	if GameManager.state == GameManager.State.Wait:
		return
	GameManager.state = GameManager.State.Wait
	match_and_color()
	GameManager.click_count += 1


func new_game():
	initialize_game()
	place_pieces()
	match_and_color()


func stop_game():
	GameManager.state = GameManager.State.Wait

