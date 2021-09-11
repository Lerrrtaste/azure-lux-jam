extends Node2D

class_name VehicleClass

#ABSOULTE directions
enum Directions {
	NONE = -1,
	LEFT,
	RIGHT,
	UP,
	DOWN
}
export(Directions) var direction_current:int = Directions.UP #starting direction
#var direction_next:int = Directions.NONE # TODO needed for the player node only

const FLOAT_PRECISION = 0.01

var allowed_distance := 0.0
var rollover_distance := 0.0 #distance remaining for target switch

export(int) var speed_base = 200 #fuer generelles balancing
var speed_modifier := 1.0 setget set_speed_modifier #wird von konkretem fahrer objekt veraendert (fuer einfluss von items, gegnerstaerka etc)
var moving := false


signal end_reached #driver answers with make_turn(...) call
signal request_new_target(vehicle,turn_vector) #city answers with set_new_target(...) call
signal moving(movement)


func _ready():
	set_process(false) #not doing anything until city registers it
	pass # Replace with function body.

#called by city after connecting required signals
func start():
	assert(get_tree().get_nodes_in_group("City").size()==1)
	get_tree().get_nodes_in_group("City")[0].register_vehicle(self)
	set_process(true)

func _process(delta:float)->void:
	#calculate how far to move this step
	var step_distance:float = speed_base * speed_modifier * delta
	
	if moving:
		_move_along(step_distance)


func _move_along(move_distance:float)->void:
	move_distance = stepify(move_distance+rollover_distance,FLOAT_PRECISION)
	rollover_distance = 0
	
	#reached target this step?
	if allowed_distance < move_distance:
		rollover_distance = move_distance - allowed_distance
		move_distance = allowed_distance
	
	#calculate movement
	var movement := direction_to_vector(direction_current)
	movement = movement.normalized() * move_distance
	
	#apply movement
	allowed_distance = stepify(allowed_distance-move_distance,FLOAT_PRECISION)
	emit_signal("moving",movement)
	
	if(rollover_distance>0):
		_end_reached()
	
	#print("moving at", movement)


func _end_reached()->void:
	#print("end reached")
	moving = false
	emit_signal("end_reached")

#simply convert direction enum to unit vector
func direction_to_vector(direction:int)->Vector2:
	var ret := Vector2()
	
	match direction_current: #apply direction
		Directions.NONE:
			pass
		Directions.LEFT:
			ret.x = -1
		Directions.RIGHT:
			ret.x = 1
		Directions.UP:
			ret.y = -1
		Directions.DOWN:
			ret.y = 1
	
	return ret.normalized()

#simply convert direction enum to unit vector
func turnvec_to_direction(turn_vector:Vector2)->int:
	var ret:int = Directions.NONE
	
	if turn_vector.x == 1:
		ret = Directions.RIGHT
	
	if turn_vector.x == -1:
		ret = Directions.LEFT
		
	if turn_vector.y == -1:
		ret = Directions.UP
	
	if turn_vector.y == 1:
		ret = Directions.DOWN
	
	return ret

#called by player or enemy ai after end_reached
func make_turn(turn_vector:Vector2)->bool:
	assert(is_processing()) # started
	
	if moving:
		return false
	
	#player input
	if turn_vector != Vector2():
		emit_signal("request_new_target",self,turn_vector)
	
	#straigt
	if turn_vector == Vector2():
		turn_vector = direction_to_vector(direction_current)
		emit_signal("request_new_target",self,turn_vector)
#
#		#straigt not possible
#		if !moving:
#			#try right
#			turn_vector = direction_to_vector(direction_current)
#			turn_vector.rotated(deg2rad(90))
#			emit_signal("request_new_target",self,turn_vector)
#
#			#right possible
#			if moving:
#				turn_vector = direction_to_vector(direction_current)
#				turn_vector.rotated(deg2rad(-180))
#				emit_signal("request_new_target",self,turn_vector)
#
#				#left possible -> two options stand still
#				if moving:
#					moving = false # more than one possibility!!! -> stand still
#				else:#only right possible
#					turn_vector = direction_to_vector(direction_current)
#					turn_vector.rotated(deg2rad(180))
#					emit_signal("request_new_target",self,turn_vector)
#			else:
#				#turn left
#				turn_vector = direction_to_vector(direction_current)
#				turn_vector.rotated(deg2rad(--90))
#				emit_signal("request_new_target",self,turn_vector)
	
	if !moving: #should be true if it succeeded
		return false
	
	direction_current = turnvec_to_direction(turn_vector)
	
	return true


#called by city after request_new_target
func allow_distance(distance:float)->void:
	moving = true
	allowed_distance = distance
	#_move_along(rollover_distance)


func set_speed_modifier(val:float)->void:
	speed_modifier = max(0.1,min(1.0,val)) 
