extends Node2D

var orders = {
	"value": 10,
	"items": [
		["Red", 1,],
		["Blue", 1],
		["Green", 1]
	],
}

onready var orders_box = $HBox/OrdersBox
onready var value_label = $HBox/Value/Value
onready var btn = $HBox/Button
const color_amount = preload("res://ColorAmout.tscn")

func _set_orders():
	for c in orders_box.get_children():
		c.queue_free()

	value_label.text = str(orders["value"])
	for item in orders["items"]:
		var order_obj = color_amount.instance()
		order_obj.set_color(item[0])
		order_obj.set_value(item[1])
		orders_box.add_child(order_obj)

	btn.disabled = !GameManager.can_complete_current_order()
	

func _ready():
	_set_orders()
	

func set_orders(new_orders):
	orders = new_orders
	_set_orders()


func _on_Button_pressed():
	GameManager.complete_order(orders)
	

func can_complete_order():
	btn.disabled = false	
