extends Node2D


# Declare member variables here. Examples:
# var a = 2
onready var marker = $targetMarker
onready var Area = $Area2D/CollisionShape2D
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
	match direction_collision :
		0:
			Area.move_local_x(-7)
		1:
			Area.move_local_x(7)
		2:
			Area.rotate(1.5708)
			Area.move_local_y(0)
			Area.move_local_x(-12)
		3:
			Area.rotate(1.5708)
			Area.move_local_y(0)
			Area.move_local_x(12)


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


func _on_Area2D_area_entered(area):
	if isTargetOfOrder :
		removeTarget()
		emit_signal("playerEntered")
		

		
