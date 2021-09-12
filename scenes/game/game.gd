extends Node2D

onready var city := $City
onready var player := $City/Player
onready var inventory := $Inventory

onready var spr_puke_effect := $SprPukeEffect
onready var lbl_hp = $VBoxContainer/LblHp
onready var lbl_score = $VBoxContainer/LblScore
onready var lbl_money = $VBoxContainer/LblMoney
onready var lbl_speed = $VBoxContainer/LblSpeed
onready var lbl_combo = $VBoxContainer/LblCombo

onready var timer_order_creation = $TimerOrderCreation

var Order = preload("res://objects/order/Order.tscn")
var Puke = preload("res://objects/enemy/puke/Puke.tscn")
var Zombie = preload("res://objects/enemy/zombie/Zombie.tscn")

var score := 0
var money := 0
var combo := 0

func _ready():
	player.position = city._get_player_spawn()
	timer_order_creation.connect("timeout",self,"_on_TimerOrderCreation_timeout")


func _process(delta):
	#### order creation ####
	if timer_order_creation.is_stopped(): #cooldown elapsed?
		var undelivered_order_count = get_tree().get_nodes_in_group("orders").size()
		if undelivered_order_count < g.ORDER_MAX_UNDELIVERED: #limit reached?
			_create_order()
	
	
	#### update puke screen effect ####
	#spr_puke_effect.modulate = ColorN("white",(1.2-player.vehicle.speed_modifier)) #TODO change
	#spr_puke_effect.position.y = -360 + 720*(1.0-player.vehicle.speed_modifier)
	
	
	#### update ui text ####
	lbl_speed.text = "Speed: %s km/h"%(player.vehicle.speed_base * player.vehicle.speed_modifier)
	lbl_hp.text = "HP: %s"%player.hp
	lbl_money.text = "Money: %s Pizza Bucks"%money
	lbl_score.text = "Score: %s"%score
	lbl_combo.text = "Combo: %sx"%combo


func _create_order()->void:
	assert(timer_order_creation.is_stopped())
	
	var inst = Order.instance()
	inst.connect("delivered",self,"_on_Order_delivered")
	add_child(inst)
	
	assert(g.ORDER_COOLDOWN_MAX>=g.ORDER_COOLDOWN_MIN)
	timer_order_creation.start((randi()%(g.ORDER_COOLDOWN_MAX-g.ORDER_COOLDOWN_MIN))+g.ORDER_COOLDOWN_MIN) #start cooldown


func _create_puke(spawn_position:Vector2)->void:
	var inst = Puke.instance()
	inst.position = spawn_position
	city.add_child(inst)


func _create_zombie(spawn_position:Vector2)->void:
	var inst = Zombie.instance()
	inst.position = spawn_position
	city.add_child(inst)

func _award_money(pos:Vector2, amount:int)->void:
	money += amount

func _award_score(pos:Vector2, amount:int)->void:
	score += amount

func _on_TimerOrderCreation_timeout()->void:
	_create_order()


func _on_Order_delivered(order:Node, delivered_to:House, secs:float):
	var position_street:Vector2 = delivered_to.position + delivered_to.area.position
	var position_house:Vector2 = delivered_to.position
	
	var score_reward := 0
	score_reward += g.ORDER_REWARD_POINTS_DELIVERED
	score_reward += combo * g.ORDER_REWARD_POINTS_COMBO
	score_reward += randi()%g.ORDER_REWARD_POINTS_RANDOM
	
	var money_bonus := randi()%g.ORDER_REWARD_MONEY_RANDOM
	
	
	if secs > g.ORDER_ZOMBIE_THRESHOLD_START: #order bad
		_create_zombie(position_street)
		_award_money(position_house,g.ORDER_REWARD_MONEY_BAD)
		_award_score(position_street,g.score_reward)
	elif secs > g.ORDER_PUKE_THRESHOLD: #order medium
		_create_puke(position_street)
	else: #good order
		combo += 1
	
	#order good
	
	print("OrderAbgeschlossen. Sekunden gebraucht: %s"%secs)
