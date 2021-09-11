extends Node2D

onready var city := $City
onready var player := $City/Player
onready var inventory := $Inventory

onready var spr_puke_effect := $SprPukeEffect
onready var lbl_hp = $VBoxContainer/LblHp
onready var lbl_score = $VBoxContainer/LblScore
onready var lbl_money = $VBoxContainer/LblMoney
onready var lbl_speed = $VBoxContainer/LblSpeed

var Order = preload("res://objects/order/Order.tscn")
var Puke = preload("res://objects/enemy/puke/Puke.tscn")

var max_active_orders := 2
var score := 0
var money := 0

func _ready():
	player.position = city._get_player_spawn()
	

func _process(delta):
	if get_tree().get_nodes_in_group("orders").size() < max_active_orders:
		_create_order()
	
	spr_puke_effect.modulate = ColorN("white",(1.2-player.vehicle.speed_modifier))
	spr_puke_effect.position.y = -360 + 720*(1.0-player.vehicle.speed_modifier)
	
	#update ui labels
	lbl_speed.text = "Speed: %s"%(player.vehicle.speed_base * player.vehicle.speed_modifier)
	lbl_hp.text = "HP: %s"%player.hp
	lbl_money.text = "Money: %s$"%money
	lbl_score.text = "Score: %s"%score

func _create_order()->void:
	var inst = Order.instance()
	inst.connect("delivered",self,"_on_Order_delivered")
	add_child(inst)

func _create_puke(spawn_position:Vector2)->void:
	var inst = Puke.instance()
	inst.position = spawn_position
	city.add_child(inst)

func _on_Order_delivered(order:Node, delivered_to:House, secs:float):
	money += 10#geld popup TODO
	score += randi()%50 + 50 #punkte popup TODO
	
	#spawn enemies if too late
	if secs > g.ORDER_PUKE_THRESHOLD:
		pass #spawn puke
	elif secs > g.ORDER_ZOMBIE_THRESHOLD_START:
		pass #spawn zombie
	
	print("OrderAbgeschlossen. Sekunden gebraucht: %s"%secs)
