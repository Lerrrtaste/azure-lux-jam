extends Node2D

onready var vehicle = $Vehicle
onready var area_body = $AreaBody

export(int) var hp := 10
var lives := 3

var current_slowdown := 0

var next_turn_input := Vector2()


func _ready():
	#setup vehicle
	vehicle.connect("end_reached",self,"_on_Vehicle_end_reached")
	vehicle.connect("moving", self, "_on_Vehicle_moving")
	vehicle.start()



func _process(delta):
	
	
	#### handel input ####

	if vehicle.moving and !$AudioStreamPlayer.playing:
		$AudioStreamPlayer.play()
	
	if !vehicle.moving and $AudioStreamPlayer.playing:
		$AudioStreamPlayer.stop()

	$Sprite.rotation = vehicle.direction_current.angle()
	$Sprite.rotation_degrees += 90

	
	#driving
	next_turn_input = Vector2()
	next_turn_input.y -= float(Input.is_action_pressed("player_drive_up"))
	next_turn_input.x += float(Input.is_action_pressed("player_drive_right"))
	next_turn_input.y += float(Input.is_action_pressed("player_drive_down"))
	next_turn_input.x -= float(Input.is_action_pressed("player_drive_left"))
	next_turn_input = next_turn_input.normalized()
	
	#cleaning
	vehicle.speed_modifier += (1.0 - vehicle.speed_modifier)/750 #autoclean
	if Input.is_action_just_pressed("player_cleanup"): # player clean
		vehicle.speed_modifier += 0.025


func _on_Vehicle_end_reached(possible_turns)->void:
	#no input
	if next_turn_input == Vector2():
		vehicle.make_turn(Vector2())
		return
	
	#one input
	if next_turn_input.x == 0 || next_turn_input.y == 0:#next_turn_input.is_normalized():
		vehicle.make_turn(next_turn_input)
		return
	
	#multiple inputs
	assert(abs(next_turn_input.x) == abs(next_turn_input.y))
	
	#calulate which input would case a direction change
	var turn_x := Vector2(next_turn_input.x,0).normalized()
	var turn_y := Vector2(0,next_turn_input.y).normalized()
	var turn_combined := turn_x+turn_y
	var turn_nonstraight:Vector2 = turn_combined
	turn_nonstraight.x *= abs(vehicle.direction_current.y)
	turn_nonstraight.y *= abs(vehicle.direction_current.x)
	
	#take turn which would lead to a direction change
	if possible_turns.has(turn_nonstraight):
		vehicle.make_turn(turn_nonstraight)
		return
	
	#go straight then
	vehicle.make_turn(Vector2())
#	if possible_turns.has(turn_y):
#		vehicle.make_turn(turn_y)
#		return
#
#	assert(false)


func _on_Vehicle_moving(movement:Vector2)->void:
	position += movement


func recieve_slowdown(slowdown_percent:float)->void:
	vehicle.speed_modifier -= slowdown_percent


func recieve_damage(damage:int)->void:
	print("Player attacked. subtracted %s hp"%damage)
	hp -= damage
	if hp <= 0:
		print("TODO game over")
