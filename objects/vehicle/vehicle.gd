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
var direction_current:=Vector2() #starting direction
var possible_next_directions := []
#var direction_next:int = Directions.NONE # TODO needed for the player node only

const FLOAT_PRECISION = 0.01

var allowed_distance := 0.0
var rollover_distance := 0.0 #distance remaining for target switch

export(int) var speed_base = 200 #fuer generelles balancing
var speed_modifier := 1.0 setget set_speed_modifier #wird von konkretem fahrer objekt veraendert (fuer einfluss von items, gegnerstaerka etc)
var moving := false


signal end_reached(possible_directions) #driver answers with make_turn(...) call
signal update_possible_directions(vehicle) #city answers with set_new_target(...) call
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
	else:
		_end_reached()


func _move_along(move_distance:float)->void:
	move_distance = stepify(move_distance+rollover_distance,FLOAT_PRECISION)
	rollover_distance = 0
	
	#reached target this step?
	if allowed_distance < move_distance:
		rollover_distance = move_distance - allowed_distance
		move_distance = allowed_distance
	
	#calculate movement
	var movement := direction_current
	movement = movement.normalized() * move_distance
	
	#apply movement
	allowed_distance = stepify(allowed_distance-move_distance,FLOAT_PRECISION)
	emit_signal("moving",movement)
	
	if(rollover_distance>0):
		_end_reached()
	
	#print("moving at", movement)


func _end_reached()->void:
	moving = false
	emit_signal("update_possible_directions",self) #TODO get possible directions from city
	
	


#called by player or enemy ai after end_reached
func make_turn(turn_vector:Vector2)->bool:
	assert(is_processing()) # started
	
	#nicht aufgefordert zum abbiegen
	if moving:
		printerr("Kann nicht waehrend bewegung abbiegen!")
		return false
	
	#remove backwards driving
	if possible_next_directions.has(direction_current*-1):
		possible_next_directions.erase(direction_current*-1)
	
	#apply driver input
	if turn_vector.length() == 1:
		if possible_next_directions.has(turn_vector): #if possible
			direction_current = turn_vector
		else:
			printerr("Driver initiated turn is not possible!")
			return false
	
	#auto turn behaviour
	if turn_vector == Vector2():
		#auto turn if only one available
		if possible_next_directions.size() == 1:
			direction_current = possible_next_directions[0]
		else:#try straigt if more than one possibility
			var straight_turn_vec = direction_current
			if possible_next_directions.has(straight_turn_vec): #straight if possible
				direction_current = straight_turn_vec
			else: #stop if there is a choice
				direction_current = Vector2()
				return false
	
	moving = true
	possible_next_directions.clear()
	vehicle.allow_distance(cell_size.x)
	return true


#called by self after request_new_target
func allow_distance(distance:float)->void:
	moving = true
	allowed_distance = distance


func set_speed_modifier(val:float)->void:
	speed_modifier = max(0.1,min(1.0,val)) 

func set_possible_directions(arr:Array)->void:
	possible_next_directions = arr
	emit_signal("end_reached",arr)
	


#simply convert direction enum to unit vector
func direction_to_vector(direction:int)->Vector2:
	assert(false) #DONT USE
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
	assert(false) #DONT USE
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
