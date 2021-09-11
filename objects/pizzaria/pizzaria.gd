extends Node2D


# Declare member variables here. Examples:
# var a = 2
onready var marker = $marker
var isPizzaReady=false
var maxOrdersPicked = 5
# var b = "text"
func _draw(): #draw the pizza ready marker
	marker.draw_circle(Vector2(), 50, ColorN("yellow", 0.2))

# Called when the node enters the scene tree for the first time.
func _ready():
	marker.visible=false

func notifyNewPizza():
	isPizzaReady=true;
	marker.visible=true;
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


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
	
