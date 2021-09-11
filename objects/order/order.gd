extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var spoiling = 0;
var pickedUp=false;
var customerHouse


# Called when the node enters the scene tree for the first time.
func _ready():
	$PizzaLogo.texture=load("res://objects/order/pizza-good.png")
	
	for i in get_tree().get_nodes_in_group("City"):
		if i.pizzeria.has_method("notifyNewPizza"):
			i.pizzeria.notifyNewPizza()

func _process(delta) :
	var spoilingLast=spoiling
	if pickedUp :
		spoiling=spoiling + delta;
		if spoiling>10 and spoilingLast<10 :
			$PizzaLogo.texture=load("res://objects/order/pizza-medium.png")
		if spoiling>20 and spoilingLast<20 :
			$PizzaLogo.texture=load("res://objects/order/pizza-infected.png")
			
			
func setPickedUp():
	pickedUp=true
	var allHouses = get_tree().get_nodes_in_group("houses")
	customerHouse=allHouses[randi() % allHouses.size()]
	customerHouse.connect("playerEntered", self, "on_Delivered")
	customerHouse.setTarget()

signal deliveredTo(house,spoiling)

func on_Delivered():
	emit_signal("deliveredTo",customerHouse,spoiling)
	set_process(false)
	queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
