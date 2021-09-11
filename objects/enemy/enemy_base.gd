extends Node2D

export(bool) var moving = false
export(int) var speed_base_offset = -200
export(float) var player_slowdown_percent = 0.25
export(int) var damage_impact = 3
export(float) var attack_cooldown = 0.5
export(int) var attack_damage = 1

onready var vehicle = $Vehicle

onready var area_slowdown = $AreaSlowdown
onready var area_body = $AreaBody
onready var area_attack = $AreaAttack
onready var timer_attack_cooldown = $TimerAttackCooldown

func _ready():
	#setup vehicle
	vehicle.speed_base += speed_base_offset
	vehicle.connect("end_reached",self,"_on_Vehicle_end_reached")
	vehicle.connect("moving", self, "_on_Vehicle_moving")
	if moving: 
		vehicle.start()
	
	#setup slowdown area
	area_slowdown.connect("area_entered",self,"_on_AreaSlowdown_area_entered")
	
	#setup attack
	area_attack.connect("area_entered",self,"_on_AreaAttack_area_entered")
	area_attack.connect("area_exited",self,"_on_AreaAttack_area_exited")
	timer_attack_cooldown.connect("timeout",self,"_on_TimerAttackCooldown_timeout")

func _on_AreaSlowdown_area_entered(area:Area2D)->void:
	var obj = area.owner
	if obj.has_method("recieve_slowdown"):
		obj.recieve_slowdown(player_slowdown_percent)
		

func _on_AreaAttack_area_entered(area:Area2D)->void:
	var obj = area.owner
	if obj.has_method("recieve_damage"):
		obj.recieve_damage(damage_impact) # impact damage
		timer_attack_cooldown.start(attack_cooldown)

func _on_AreaAttack_area_exited(area:Area2D)->void:
	var obj = area.owner
	if obj.has_method("recieve_damage"):
		timer_attack_cooldown.stop()

func _on_TimerAttackCooldown_timeout()->void:
	var obj = area_attack.get_overlapping_areas()[0]
	if obj.has_method("recieve_damage"):
		obj.recieve_damage(attack_damage)
