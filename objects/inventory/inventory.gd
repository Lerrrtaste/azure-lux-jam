extends Node2D

var orders:Array
var slots_unlocked := 4
var upgrade_available := false

onready var spr_slot_template = $SprBackpack/SlotTemplate
onready var spr_backpack = $SprBackpack

var spr_slots:Array

signal upgrade()

func _ready():
	for i in range(g.INVENTORY_SLOTS_MAX):
		var inst = spr_slot_template.duplicate()
		inst.offset.y = i*(inst.texture.get_height()/inst.vframes)
		spr_backpack.add_child(inst)
		spr_slots.append(inst)
	spr_slot_template.visible = false
	spr_slot_template.queue_free()


func _process(delta):
	for i in range(g.INVENTORY_SLOTS_MAX):
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
		elif slots_unlocked <= i:#locked
			spr_slots[i].frame = 0 
		else: #unlocked but empty yeet
			spr_slots[i].frame = 4

func _on_Game_slot_purchased()->void:
	slots_unlocked += 1

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
