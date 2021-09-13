extends Node2D

var orders:Array
var slots_unlocked := 1
var upgrade_available := false

onready var spr_slot_template = $SprBackpack/SlotTemplate
onready var spr_backpack = $SprBackpack

var spr_slots:Array

signal upgraded(cost)

func _ready():
	for i in range(g.INVENTORY_SLOTS_MAX):
		var inst = spr_slot_template.duplicate()
		inst.offset.y = i*(inst.texture.get_height()/inst.vframes)
		spr_backpack.add_child(inst)
		spr_slots.append(inst)
	spr_slot_template.visible = false
	spr_slot_template.queue_free()


func _process(delta):
	if Input.is_action_just_pressed("inventory_upgrade") && upgrade_available:
		_buy_upgrade()
	
	for i in range(g.INVENTORY_SLOTS_MAX):
		var frame:int = 2 #unlocked but empty yeet
		
		if slots_unlocked <= i:#locked
			frame = 0 
		
		if slots_unlocked == i && upgrade_available: #is available for purchase
			frame = 1
		
		#filled with pizza
		if orders.size() > i:
			
			# good pizza
			if orders[i].seconds_passed <= g.ORDER_PUKE_THRESHOLD:
				frame = 3
			
			#medium pizza
			if orders[i].seconds_passed > g.ORDER_PUKE_THRESHOLD:
				frame = 4 
			
			#bad pizza
			if orders[i].seconds_passed > g.ORDER_ZOMBIE_THRESHOLD_START:
				frame = 5 
			
		spr_slots[i].frame = frame


func _buy_upgrade()->void:
	assert(upgrade_available)
	emit_signal("upgraded",get_upgrade_cost())
	upgrade_available = false
	slots_unlocked += 1


func order_add(order:Node)->bool:
	#is there enough space?
	if orders.size() >= slots_unlocked:
		print("cant pick up, inventory full")
		return false
	orders.append(order)
	order.connect("delivered",self,"_on_Order_delivered")
	return true


func get_upgrade_cost()->int:
	return g.INVENTORY_UPGRADE_COST_BASE + (slots_unlocked-1)*g.INVENTORY_UPGRADE_COST_INCREASE


func _on_Game_money_changed(delta:int,total:int)->void:
	if slots_unlocked >= g.INVENTORY_SLOTS_MAX:
		return
	
	upgrade_available = (total >= get_upgrade_cost())


func _on_Order_delivered(order:Node,house:Node,delivery_time_secs:float)->void:
	#remove from orders array
	orders.erase(order)
