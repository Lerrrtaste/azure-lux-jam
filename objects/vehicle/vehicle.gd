extends Node2D

var street_node:StreetClass
var street_position := 0.0
var reversed := false

export(int) var speed_base = 100
var speed_modifier := 1.0

signal end_reached(left_available,straigt_available, right_available)

func _ready():
	pass # Replace with function body.

func _process(delta:float)->void:
	var step_distance:float = speed_base * speed_modifier * delta
	
	#reached end of street?
	if street_position + step_distance > street_node.get_street_length():
		_end_reached()
	
	#move along street
	street_position += delta
	if(street_position == (0 if reversed else 1)):
		emit_signal("end_reached")
	pass

func _end_reached()->void:
	pass

func make_turn(direction)->bool:
	return false
