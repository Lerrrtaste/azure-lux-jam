extends Node2D

export(bool) var moving = false
export(int) var speed_base_offset = -200
export(float) var player_slowdown_percent = 0.25
export(int) var damage_impact = 3
export(int) var damage_time = 1

onready var vehicle = $Vehicle

onready var area_slowdown = $AreaSlowdown
onready var area_body = $AreaBody
onready var area_attack = $AreaAttack

func _ready():
	#setup vehicle
	vehicle.speed_base += speed_base_offset
	vehicle.connect("end_reached",self,"_on_Vehicle_end_reached")
	vehicle.connect("moving", self, "_on_Vehicle_moving")
	if moving: 
		vehicle.start()
	
	#setup slowdown area
	area_slowdown.connect("area_entered",self,"_on_AreaSlowdown_area_entered")

func _on_AreaSlowdown_area_entered(area:Area2D)->void:
	var obj = area.owner
	if obj.has_method("recieve_slowdown"):
		obj.recieve_slowdown(player_slowdown_percent)
		
