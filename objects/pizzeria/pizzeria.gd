extends Node2D

onready var marker = $marker
var pizzas_ready=0

signal player_picking_up

#draw the pizza ready marker
func _draw():
	if pizzas_ready>0:
		draw_circle(Vector2(), 50, ColorN("yellow", 0.2))

func _ready():
	marker.visible=false #no function atm

func notifyNewPizza():
	pizzas_ready+=1
	marker.visible=true #no function atm

func notifyRemovedPizza():
	pizzas_ready-=1

func _process(delta):
	update()

func _on_Area2D_area_entered(area):
	emit_signal("player_picking_up")
#	var allOrders = get_tree().get_nodes_in_group("orders")
#	var cnt=0 #counts the number of not picked up order
##	#var addedOrders=0 # cout not picked up orders that could be added to the backpack
#	for i in allOrders:
#		if !i.pickedUp:
#			cnt=cnt+1
#			i.pick_up()
##			if cnt <= maxOrdersPicked :
##				addedOrders=cnt
#	if cnt == 0: # all ordes could be picked up
#		pizzas_ready=0;
#		marker.visible=false;

