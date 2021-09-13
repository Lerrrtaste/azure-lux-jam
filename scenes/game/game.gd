extends Node2D

onready var city := $City
onready var player := $City/Player
onready var inventory := $Inventory

onready var spr_puke_effect := $SprPukeEffect
onready var lbl_hp = $VBoxContainer/LblHp
onready var lbl_score = $VBoxContainer/LblScore
onready var lbl_money = $VBoxContainer/LblMoney
onready var lbl_speed = $VBoxContainer/LblSpeed
#onready var lbl_combo = $VBoxContainer/LblCombo

onready var timer_order_creation = $TimerOrderCreation

var Order = preload("res://objects/order/Order.tscn")
var Puke = preload("res://objects/enemy/puke/Puke.tscn")
var Zombie = preload("res://objects/enemy/zombie/Zombie.tscn")

var PopUp = preload("res://objects/popup/Popup.tscn") 

var score := 0
var money := 0
var combo := 0

signal money_changed(delta,total)
signal score_added(added,total)

func _ready():
	randomize()
	player.position = city._get_player_spawn()
	#timer_order_creation.connect("timeout",self,"_on_TimerOrderCreation_timeout")
	connect("money_changed",inventory,"_on_Game_money_changed")
	inventory.connect("upgraded",self,"_on_Inventory_upgraded")


func _process(delta):
	if !$AudioStreamPlayer.playing :
		$AudioStreamPlayer.play()
	#game over condition
	if player.hp <= 0:
		get_tree().change_scene("res://scenes/gameover/GameOver.tscn")
	
	#### order creation ####
	var undelivered_order_count = get_tree().get_nodes_in_group("orders").size()
	if  (undelivered_order_count == 0 && (timer_order_creation.time_left<g.ORDER_COOLDOWN_MIN)): # skip if no order
		timer_order_creation.stop()
	
	if timer_order_creation.is_stopped(): #cooldown elapsed? 
		if undelivered_order_count < g.ORDER_MAX_QUEUED+inventory.slots_unlocked: #limit reached?
			_create_order()
	
	
	#### update puke screen effect ####
	spr_puke_effect.modulate.a = 1.2-player.vehicle.speed_modifier
	spr_puke_effect.position.y = -720*(player.vehicle.speed_modifier)
	
	
	#### update ui text ####
	lbl_speed.text = "Speed: %s km/h"%(player.vehicle.speed_base * player.vehicle.speed_modifier)
	lbl_hp.text = "HP: %s"%player.hp
	lbl_money.text = "Money: %s Pizza Bucks"%money
	lbl_score.text = "Score: %s"%score
	#lbl_combo.text = "Combo: %sx"%combo


func _create_order()->void:
	assert(timer_order_creation.is_stopped())
	
	var inst = Order.instance()
	inst.connect("delivered",self,"_on_Order_delivered")
	add_child(inst)
	
	assert(g.ORDER_COOLDOWN_MAX>=g.ORDER_COOLDOWN_MIN)
	var undelivered_order_count = get_tree().get_nodes_in_group("orders").size()
	timer_order_creation.start(undelivered_order_count*(randi()%((g.ORDER_COOLDOWN_MAX-g.ORDER_COOLDOWN_MIN))+g.ORDER_COOLDOWN_MIN)) #start cooldown
	print("New order in ", timer_order_creation.time_left)
	
	_show_popup("New Order",city.pizzeria.position,city.pizzeria.position)


func _create_puke(spawn_position:Vector2)->void:
	yield(get_tree().create_timer(.25),"timeout") #TODO puke spawn anim
	var inst = Puke.instance()
	inst.position = spawn_position
	city.add_child(inst)


func _create_zombie(spawn_position:Vector2,strength:float)->void:
	var inst = Zombie.instance()
	inst.strength = strength
	inst.position = spawn_position
	city.add_child(inst)


func _add_money(amount:int, pos:Vector2=Vector2() )->void:
	money += amount
	emit_signal("money_changed",amount,money)
	if pos != Vector2():
		_show_popup("%s$"%amount,pos+city.cell_size/2,Vector2())

func _award_score(amount:int, pos:Vector2=Vector2())->void:
	yield(get_tree().create_timer(0.2),"timeout")
	score += amount
	emit_signal("score_added",amount,score)
	if pos != Vector2():
		_show_popup("%s Points"%amount,player.position,Vector2())

func _show_popup(text:String,from:Vector2,to:Vector2)->void:
	var inst = PopUp.instance()
	city.add_child(inst)
	inst.start(text,from,to)

func _on_Inventory_upgraded(cost:int)->void:
	assert(cost <= money)
	_add_money(-cost)

#
#func _on_TimerOrderCreation_timeout()->void:
#	_create_order()


func _on_Order_delivered(order:Node, delivered_to:House, secs:float):
	var position_street:Vector2 = delivered_to.position + delivered_to.area.position
	var position_house:Vector2 = delivered_to.position
	
	var score_reward := 0
	score_reward += g.ORDER_REWARD_POINTS_DELIVERED
	score_reward += randi()%g.ORDER_REWARD_POINTS_RANDOM
	
	var money_bonus := 0
	money_bonus +=randi()%g.ORDER_REWARD_MONEY_RANDOM
	
	#issue rewards based on delivery thresholds
	if secs > g.ORDER_ZOMBIE_THRESHOLD_START: #order bad
		#combo = 0
		var strength = clamp((secs - g.ORDER_ZOMBIE_THRESHOLD_START) / (g.ORDER_ZOMBIE_THRESHOLD_END-g.ORDER_ZOMBIE_THRESHOLD_START),0.0,1.0)
		print("zombie strength: ",strength)
		_create_zombie(position_street,strength)
		_add_money(g.ORDER_REWARD_MONEY_BAD,position_house)
		_award_score(score_reward,position_street)
		
	elif secs > g.ORDER_PUKE_THRESHOLD: #order medium
		#combo = 0
		_create_puke(position_street)
		_add_money(g.ORDER_REWARD_MONEY_MEDIUM,position_house)
		_award_score(score_reward,position_street)
		
	else: #good order
		#score_reward += combo * g.ORDER_REWARD_POINTS_COMBO
		score_reward += g.ORDER_REWARD_POINTS_INTIME
		#combo += 1
		_award_score(score_reward,position_street)
		_add_money(g.ORDER_REWARD_MONEY_GOOD,position_house)
		
	
	#order good
	
	print("OrderAbgeschlossen. Sekunden gebraucht: %s"%secs)
