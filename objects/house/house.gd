extends Node2D

class_name House

onready var marker = $targetMarker
onready var area = $Area2D
onready var icon = $main
onready var tween = $Tween
var isTargetOfOrder=false

# set marker to display a circle
func _draw():
	if isTargetOfOrder:
		pass#draw_circle(Vector2(), 24, ColorN("yellow", 0.2))


#to variable set the collision area position
enum directions {y
	LEFT,
	RIGHT,
	UP,
	DOWN
}
export(directions) var direction_collision: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	$main.texture = load("res://objects/house/house%s.png"%(randi()%2+1))
	
	marker.visible=false
	#set position according to editor position

	match direction_collision :
		directions.LEFT:
			area.position.x=-24
			#icon.rotate(0)
			icon.set_flip_h(true)
			$decoration.set_flip_h(true)
			#$decoration.rotate(0)
			$decoration.texture = load("res://objects/house/door_side%s.png"%(randi()%4+1))
		directions.RIGHT:
			area.position.x=24
			icon.set_flip_h(false)
			$decoration.set_flip_h(false)
			$decoration.texture = load("res://objects/house/door_side%s.png"%(randi()%4+1))
		directions.UP:
			#icon.rotate(1.5708)
			area.position.y=-24
			#$decoration.rotate(1.5708)
			#$decoration.texture = load("res://objects/house/house%s.png"%(randi()%2+1))
		directions.DOWN:
			area.position.y=24
			#icon.rotate(-1.5708)
			#$decoration.rotate(-1.5708)
			
			$decoration.texture = load("res://objects/house/door_front%s.png"%(randi()%3+1))



# set unset marker functions
func setTarget():
	if isTargetOfOrder :
		printerr("waring house is already target")
	else:
		print("setting house to target")
	marker.visible=true
	tween.interpolate_property(marker,"scale",Vector2(),Vector2(1.5,1.5),1.0,Tween.TRANS_ELASTIC,Tween.EASE_OUT)
	tween.interpolate_property(marker,"scale",Vector2(1.5,1.5),Vector2(1,1),5.0,Tween.TRANS_BACK,Tween.EASE_OUT,1.1)
	tween.start()
	isTargetOfOrder=true
	
func removeTarget():
	if isTargetOfOrder :
		print("remove the house as target")
	else:
		printerr("warning house already isnt target")
	var strm = $AudioStreamPlayer.stream as AudioStreamMP3
	strm.set_loop(false)
	$AudioStreamPlayer.play()
	marker.visible=false
	isTargetOfOrder=false


#code handling player entry
signal playerEntered


func _process(delta):
	update()

#Called by city to (before entering tree / before _ready() is called) 
func set_direction(val:int)->void:
	direction_collision = val

func _on_Area2D_area_entered(area):
	if isTargetOfOrder :
		removeTarget()
		emit_signal("playerEntered")
