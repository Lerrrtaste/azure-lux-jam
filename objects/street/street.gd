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
