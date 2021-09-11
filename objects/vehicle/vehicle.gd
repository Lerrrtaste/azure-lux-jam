extends Node2D

var street_node:StreetClass #aktuelle street
var street_position := 0.0 #distanz von a (bzw b bei reversed) 
var reversed := false #wenn true von b->a
var rollover_distance := 0.0 #verbleibende distanz nach end_of_street; mitzunehmen auf naechste straße

export(int) var speed_base = 100 #fuer generelles balancing
var speed_modifier := 1.0 #wird von konkretem fahrer objekt veraendert (fuer einfluss von items, gegnerstaerka etc)
var moving := true

signal end_reached(left_available,straigt_available, right_available)

func _ready():
	pass # Replace with function body.

func _process(delta:float)->void:
	#calculate how far to move this step
	var step_distance:float = speed_base * speed_modifier * delta
	
	if moving:
		_move_along(step_distance)


func _move_along(distance:float)->void:
	#calculate new position
	var new_street_position = street_position + distance
	
	#reached end of street?
	if new_street_position > street_node.get_street_length():
		_end_reached(new_street_position - street_node.get_street_length())
	else:
		#move along street
		street_position += distance
	


func _end_reached(leftover_distance:float)->void:
	assert(sign(leftover_distance) < 1)
	
	rollover_distance = leftover_distance
	moving = false
	emit_signal("end_reached")


func make_turn(next_street:Node)->bool:
	return false
