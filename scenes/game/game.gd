extends Control

onready var city := $City
onready var player := $City/Player

#var Order = preload("res://objects/order/order.tscn")

export(int) var max_active_orders := 1
var active_orders := 0
var score := 0
var money := 0

func _ready():
	player.position = city._get_player_spawn()


func _create_order()->void:
	pass

func _on_Order_delivered(delivered_to:House, spoiler):
	pass
	
