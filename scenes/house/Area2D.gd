extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var aHouse = $House


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

signal playerEntered
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_area_entered(area):
	if aHouse.isTargetOfOrder :
		aHouse.removeTarget()
		emit_signal("playerEntered")
