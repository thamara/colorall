extends Node

enum Colors { Black = 0, White, Red, Yellow, Blue, Purple, Green, Orange}
enum State { Wait, Ready }

var color_selected = Colors.Black
var score = 0
var state = State.Wait


const EnumToName = {
	Colors.Black: "Black",
	Colors.White: "White",
	Colors.Red: "Red",
	Colors.Yellow: "Yellow",
	Colors.Blue: "Blue",
	Colors.Purple: "Purple",
	Colors.Green: "Green",
	Colors.Orange: "Orange",
}

const ColorNameToEnum = {
	"Black": Colors.Black,
	"White": Colors.White,
	"Red": Colors.Red,
	"Yellow": Colors.Yellow,
	"Blue": Colors.Blue,
	"Purple": Colors.Purple,
	"Green": Colors.Green,
	"Orange": Colors.Orange,
}

const tiles = [
	["Black", preload("res://tiles/Black.tscn")],
	["White", preload("res://tiles/White.tscn")],
	["Red", preload("res://tiles/Red.tscn")],
	["Yellow", preload("res://tiles/Yellow.tscn")],
	["Blue", preload("res://tiles/Blue.tscn")],
	["Purple", preload("res://tiles/Purple.tscn")],
	["Green", preload("res://tiles/Green.tscn")],
	["Orange", preload("res://tiles/Orange.tscn")],
]

var cnt = {
		Colors.Black: 0,
		Colors.White: 0,
		Colors.Red: 0,
		Colors.Yellow: 0,
		Colors.Blue: 0,
		Colors.Purple: 0,
		Colors.Green: 0,
		Colors.Orange: 0,
}

var cnt_ui = {
	Colors.Black: null,
	Colors.White: null,
	Colors.Red: null,
	Colors.Yellow: null,
	Colors.Blue: null,
	Colors.Purple: null,
	Colors.Green: null,
	Colors.Orange: null,
}

var possible_orders = [
	{
		"value": 10,
		"items": [
			["Purple", 1,],
			["Blue", 1],
			["Red", 1]
		],
	},
	{
		"value": 100,
		"items": [
			["Red", 1,],
			["Yellow", 1],
			["Purple", 1]
		],
	},
	{
		"value": 100,
		"items": [
			["Orange", 1,],
		],
	},
]
var order_it = 0

signal counter_changed

var order = null


func number_to_color(n):
	var n_to_c = {
		0: Colors.Black,
		1: Colors.White,
		2: Colors.Red,
		3: Colors.Yellow,
		4: Colors.Blue,
		5: Colors.Purple,
		6: Colors.Green,
		7: Colors.Orange,
	}
	return n_to_c[n]


func set_color(n):
	color_selected = number_to_color(n)


func reset_cnt():
	for color in cnt:
		cnt[color] = 0


func set_color_val(color, val):
	cnt[color] = val
	cnt_ui[color].text = str(cnt[color])
	emit_signal("counter_changed")


func incr_color_cnt(color_name):
	var color = ColorNameToEnum[color_name]
	set_color_val(color, cnt[color] + 1)
	if can_complete_current_order():
		order.can_complete_order()


func register_cnt_ui(ui):
	pass


func register_order_ui(ui):
	order = ui


func can_complete_order(orders):
	var can_complete = true
	for item in orders["items"]:
		var color = ColorNameToEnum[item[0]]
		var amount = item[1]
		var current_color_amout = cnt[color]
		if current_color_amout < amount:
			can_complete = false
	return can_complete


func can_complete_current_order():
	if !order:
		return false
	var current_order = order.orders
	return can_complete_order(current_order)


func complete_order(orders):
	for item in orders["items"]:
		var color = ColorNameToEnum[item[0]]
		var amount = item[1]
		set_color_val(color, cnt[color] - amount)
	if order_it >= len(possible_orders):
		order_it = 0
	order.set_orders(possible_orders[order_it])
	order_it += 1


func _ready():
	pass # Replace with function body.
