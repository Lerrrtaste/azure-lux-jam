extends Line2D

class_name StreetClass

export(NodePath) var a_left_street
export(NodePath) var a_right_street
export(NodePath) var a_straight_street

export(NodePath) var b_left_street
export(NodePath) var b_right_street
export(NodePath) var b_straight_street


func _ready():
	set_process(false)
	pass


func _process(delta:float)->void:
	pass


func get_street_length()->float:
	if points.size() < 2:
		return 0.0
	
	return points[0].distance_to(points[points.size()-1])


func get_next_streets(reversed:bool)->Dictionary:
	var ret := {
		"left": is_instance_valid(get_node(b_left_street if reversed else a_left_street)),
		"straigt": is_instance_valid(get_node(b_straight_street if reversed else a_straight_street)),
		"right": is_instance_valid(get_node(b_right_street if reversed else a_right_street))
	}
	return ret
