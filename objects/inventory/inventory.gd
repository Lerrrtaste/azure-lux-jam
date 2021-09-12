extends Node2D

var orders:Array
var slots_unlocked := 3

onready var spr_slots = [$SprBackpack/Slot1,$SprBackpack/Slot2,$SprBackpack/Slot3]


func _ready():
	pass


func _process(delta):
	for i in range(3):
		#filled with pizza
		if orders.size() > i:
			var frame:int
			
			# good pizza
			if orders[i].seconds_passed <= g.ORDER_PUKE_THRESHOLD:
				frame = 1 
			
			#medium pizza
			if orders[i].seconds_passed > g.ORDER_PUKE_THRESHOLD:
				frame = 2 
			
			#bad pizza
			if orders[i].seconds_passed > g.ORDER_ZOMBIE_THRESHOLD_START:
				frame = 3 
			
			spr_slots[i].frame = frame
			spr_slots[i].visible = true
		elif slots_unlocked <= i:#locked
			spr_slots[i].frame = 0 
			spr_slots[i].visible = true
		else: #unlocked but empty yeet
			spr_slots[i].visible = false


func order_add(order:Node)->bool:
	#is there enough space?
	if orders.size() >= slots_unlocked:
		print("cant pick up, inventory full")
		return false
	orders.append(order)
	order.connect("delivered",self,"_on_Order_delivered")
	return true


func _on_Order_delivered(order:Node,house:Node,delivery_time_secs:float)->void:
	#remove from orders array
	orders.erase(order)
