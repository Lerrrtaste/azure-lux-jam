extends Node2D

class_name HouseClass

# Declare member variables here. Examples:
# var a = 2
onready var marker = $targetMarker
onready var area = $Area2D
onready var icon = $main
var isTargetOfOrder=false

# var b = "text"

# set marker to display a circle
func _draw():
	marker.draw_circle(Vector2(), 24, ColorN("yellow", 0.2))
	
	
#to variable set the collision area position
enum directions {
	LEFT,
	RIGHT,
	UP,
	DOWN
}
export(directions) var direction_collision: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	marker.visible=false
	#set position according to editor position
<<<<<<< HEAD
	match direction_collision :
		directions.LEFT:
			area.position.x=-24
			icon.rotate(0)
		directions.RIGHT:
			area.position.x=24
			icon.set_flip_h(true)
		directions.UP:
			icon.rotate(1.5708)
			area.position.y=-24
		directions.DOWN:
			area.position.y=24
			icon.rotate(-1.5708)
>>>>>>> 5fce755ebe4f9db48a2f8a1e726a7fd654b30e09


# set unset marker functions
func setTarget():
	if isTargetOfOrder :
		print("waring house is already target")
	else:
		print("setting house to target")
	marker.visible=true
	isTargetOfOrder=true
	
func removeTarget():
	if isTargetOfOrder :
		print("remove the house as target")
	else:
		print("warning house already isnt target")
	marker.visible=false
	isTargetOfOrder=false


#code handling player entry
signal playerEntered
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#Called by city to (before entering tree / before _ready() is called) 
func set_direction(val:int)->void:
	direction_collision = val

func _on_Area2D_area_entered(area):
	if isTargetOfOrder :
		removeTarget()
		emit_signal("playerEntered")
		

		
