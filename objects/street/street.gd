extends Line2D

class_name StreetClass

onready var pointA = get_node("PointA")
onready var pointB = $PointB

export(NodePath) var left_path
export(NodePath) var right_path
export(NodePath) var straight_path

func _ready():
	set_process(false)
	pass

func _process(delta:float)->void:
	pass

func get_street_length()->float:
	if points.size() < 2:
		return 0.0
	
	return points[0].distance_to(points[points.size()-1])
