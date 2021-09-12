extends Node2D

const  visionRange:=50
const boostOnPlayerDetection=2
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var vehicle:= $Vehicle
onready var rayCast2D:= $RayCast2D
var following:=false

# Called when the node enters the scene tree for the first time.
func _ready():
	var cnt:=0.0
	while cnt < 1:
		cnt =cnt + 0.1
	vehicle.connect("end_reached",self,"_on_Vehicle_end_reached")
	vehicle.connect("moving", self, "_on_Vehicle_moving")

func _draw():
	if following : #draw the circle according to the following status
		draw_circle(Vector2(), 18, ColorN("red", 0.3))
	
	
func _process(delta):
	if rayCast2D.get_collider().owner.is_class("player"): #check wether player is in vision
		following=true
	else:
		following=false

func _on_Vehicle_end_reached(A:Array):
	update() #draw the circle according to the following status
	if !following :
		if A.empty() :
			printerr("cant move to any direction")
		else :
			var i:= randi()%A.size() #select random possilbe direction
			var tmp:Vector2=A[i]
			vehicle.make_turn(A[i]) #trun to teh sevted direction
			tmp.x=tmp.x*visionRange #change raycast to new movement direction
			tmp.y=tmp.y*visionRange
			rayCast2D.cast_to=tmp
	else:
		vehicle.make_turn(Vector2(0,0))	 #run forwand until we loose the player
func _on_Vehicle_moving(movement):
	  position = position + movement * boostOnPlayerDetection

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

