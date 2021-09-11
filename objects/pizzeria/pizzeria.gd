extends Node2D


# Declare member variables here. Examples:
# var a = 2
onready var marker = $marker
var isPizzaReady=false
var maxOrdersPicked = 5

func _draw(): #draw the pizza ready marker
	if isPizzaReady:
		draw_circle(Vector2(), 50, ColorN("yellow", 0.2))

# Called when the node enters the scene tree for the first time.
func _ready():
	marker.visible=false #no function atm

func notifyNewPizza():
	isPizzaReady=true
	marker.visible=true #no function atm

func _process(delta):
	update()

func _on_Area2D_area_entered(area):
	var allOrders = get_tree().get_nodes_in_group("orders")
	var cnt=0 #counts the number of not picked up orders
	var addedOrders=0 # cout not picked up orders that could be added to the backpack
	for i in allOrders :
		if !i.pickedUp :
			cnt=cnt+1
			if cnt <= maxOrdersPicked :
				i.setPickedUp()
				addedOrders=cnt
	if cnt == addedOrders : # all ordes could be picked up
		isPizzaReady=false;
		marker.visible=false;
	
