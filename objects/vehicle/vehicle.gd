extends Node2D

class_name VehicleClass

enum Directions {
	NONE = -1,
	LEFT,
	RIGHT,
	UP,
	DOWN
}
export(Directions) var direction_current:int = Directions.UP #starting direction
#var direction_next:int = Directions.NONE # TODO needed for the player node only

var target_position := Vector2()
var rollover_distance := 0.0 #distance remaining for target switch

export(int) var speed_base = 100 #fuer generelles balancing
var speed_modifier := 1.0 #wird von konkretem fahrer objekt veraendert (fuer einfluss von items, gegnerstaerka etc)
var moving := false

signal end_reached
signal request_new_target(current_pos,turn_vector)

func _ready():
	set_process(false) #not doing anything until city registers it
	pass # Replace with function body.

#called by city after connecting required signals
func start():
	set_process(true)

func _process(delta:float)->void:
	#calculate how far to move this step
	var step_distance:float = speed_base * speed_modifier * delta
	
	if moving:
		_move_along(step_distance)


func _move_along(move_distance:float)->void:
	#reached target this step?
	var distance_to_target := position.distance_to(target_position)
	
	if  distance_to_target < move_distance:
		_end_reached(move_distance-distance_to_target)
		move_distance = distance_to_target
	
	#calculate movement
	var movement := _direction_to_vector(direction_current)
	movement = movement.normalized() * move_distance
	
	#apply movement
	position += movement


func _end_reached(leftover_distance:float)->void:
	assert(sign(leftover_distance) < 1)
	
	rollover_distance = leftover_distance
	moving = false
	emit_signal("end_reached")

#simply convert direction enum to unit vector
func _direction_to_vector(direction:int)->Vector2:
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


#called by player or enemy ai after end_reached
func make_turn(next_direction:int)->bool:
	var turn_vector := _direction_to_vector(next_direction)
	emit_signal("request_new_target",position,turn_vector)
	
	return true


#called by city after request_new_target
func set_new_target(target:Vector2)->void:
	moving = true
	
