extends Node2D

onready var vehicle = $Vehicle
onready var area_body = $AreaBody

export(int) var hp := 10
var lives := 3

var current_slowdown := 0

var next_turn := Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	#setup vehicle
	vehicle.connect("end_reached",self,"_on_Vehicle_end_reached")
	vehicle.connect("moving", self, "_on_Vehicle_moving")
	vehicle.start()
	#vehicle.make_turn(Vector2(0,0))
	
	#area_body.connect("area_entered",self,"_on_AreaBody_area_entered")


func _process(delta):
	vehicle.speed_modifier += (1.0 - vehicle.speed_modifier)/750
	#print(vehicle.speed_modifier)

func _on_Vehicle_end_reached(possible_turns)->void:
	if next_turn.length() > 0 && vehicle.make_turn(next_turn):
		pass#next_turn = Vector2() #clear next turn cache
	else:
		vehicle.make_turn(Vector2()) #player turn not possible, auto turn behaviour


func _on_Vehicle_moving(movement:Vector2)->void:
	position += movement


func recieve_slowdown(slowdown_percent:float)->void:
	vehicle.speed_modifier -= slowdown_percent


func recieve_damage(damage:int)->void:
	print("Player attacked. subtracted %s hp"%damage)
	hp -= damage
	if hp <= 0:
		print("TODO game over")

func _unhandled_key_input(event):
	if event.pressed:
		if event.scancode == KEY_W:
			next_turn = (Vector2(0,-1)) 
		
		if event.scancode == KEY_A:
			next_turn = (Vector2(-1,0)) 
		
		if event.scancode == KEY_S:
			next_turn = (Vector2(0,1)) 
		
		if event.scancode == KEY_D:
			next_turn = (Vector2(1,0)) 
	
	
	if !vehicle.moving:
		vehicle.make_turn(next_turn)
	
	if event.scancode == KEY_SPACE && vehicle.speed_modifier < 1.0:
		vehicle.speed_modifier += 0.025
