extends Node2D

onready var vehicle = $Vehicle

var hp := 100
var lives := 3

var next_turn := Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	#setup vehicle
	vehicle.connect("end_reached",self,"_on_Vehicle_end_reached")
	vehicle.connect("moving", self, "_on_Vehicle_moving")
	vehicle.start()
	#vehicle.make_turn(Vector2(0,0))


func _on_Vehicle_end_reached()->void:
	if vehicle.make_turn(next_turn):
		next_turn = Vector2() #wait for new turn signal
	else:
		vehicle.make_turn(Vector2()) #player turn not possible (yet) keep straight or stop
	

func _on_Vehicle_moving(movement:Vector2)->void:
	position += movement

func _unhandled_key_input(event):
	if !event.pressed:
		return
	
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
