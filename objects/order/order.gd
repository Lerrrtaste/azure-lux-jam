extends Node

var seconds_passed = 0.0
var picked_up=false
var customerHouse
var pizzeria

signal delivered(order,house,delivery_time_secs)

func _ready():
	set_process(false)
	
	#find pizzaria
	for i in get_tree().get_nodes_in_group("City"):
		if i.has_node("Pizzeria"):
			pizzeria = i.pizzeria
	
	assert(pizzeria.has_method("notifyNewPizza"))
	
	#notify pizzeria so it activates the marker
	pizzeria.notifyNewPizza()
	
	#watch for the player driving by the pizzeria
	pizzeria.connect("player_picking_up",self,"_on_Pizzeria_player_picking_up")


func _process(delta) :
	seconds_passed += delta


func _on_Pizzeria_player_picking_up():
	assert(!picked_up)
	assert(get_tree().get_nodes_in_group("Inventory").size()==1)
	
	#check if inventory has enough space
	var inventory = get_tree().get_nodes_in_group("Inventory")[0]
	if !inventory.order_add(self):
		return # inventory full: do nothing
	
	picked_up=true
	pizzeria.disconnect("player_picking_up",self,"_on_Pizzeria_player_picking_up") # not needed anymore
	pizzeria.notifyRemovedPizza()
	set_process(true)
	
	#select customer house
	var allHouses = get_tree().get_nodes_in_group("houses")
	customerHouse=allHouses[randi() % allHouses.size()]
	customerHouse.connect("playerEntered", self, "_on_House_player_entered")
	customerHouse.setTarget()


func _on_House_player_entered():
	assert(picked_up)
	
	#notifies game node to spawn enemy and award points/money
	#notifies inventory to no longer display this order 
	emit_signal("delivered",self,customerHouse,seconds_passed)
	
	#delete
	set_process(false)
	queue_free()
