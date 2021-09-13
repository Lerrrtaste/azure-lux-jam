extends Node2D

var  visionRange:=g.ENEMY_ZOMBIE_VISION_RANGE
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var vehicle:= $EnemyBase/Vehicle
onready var rayCast2D:= $RayCast2D
var lastPlayerPos:=Vector2(0,0)
var following:=false
var spawed:=false
var strength:=-1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(strength>=0.0 && strength<=1.0 )
	vehicle.set_speed_modifier(g.ENEMY_ZOMBIE_DEFAULT_SPEED) #set deafult spped of the zombie
	$EnemyBase.damage_impact=g.ENEMY_ZOMBIE_DAMAGE #set damage to enemy base
	$EnemyBase.attack_cooldown=g.ENEMY_ZOMBIE_ATTACK_COOLDOWN
	vehicle.connect("end_reached",self,"_on_Vehicle_end_reached")
	vehicle.connect("moving", self, "_on_Vehicle_moving")

func _draw():
	if following : #draw the circle according to the following status
		draw_circle(Vector2(), 18, ColorN("red", 0.3))
	
	
func _process(delta):
	if rayCast2D.is_colliding():
		var collider=rayCast2D.get_collider().get_parent()
		if collider.is_in_group("Players"): #check wether player is in vision
			print("player in vision")
			lastPlayerPos=collider.get_global_position()
			following=true


func _on_Vehicle_end_reached(A:Array):
	update() #draw the circle according to the following status
	if !following :
		vehicle.set_speed_modifier(g.ENEMY_ZOMBIE_DEFAULT_SPEED)
		if A.empty() :
			printerr("cant move to any direction")
		else :
			var i:= randi()%A.size() #select random possilbe direction
			var tmp:Vector2=A[i]
			vehicle.make_turn(tmp) #trun to teh sevted direction
			tmp.x=tmp.x*visionRange #change raycast to new movement direction
			tmp.y=tmp.y*visionRange
			rayCast2D.cast_to=tmp
			print("Soos")
	else:
		vehicle.set_speed_modifier(g.ENEMY_ZOMBIE_SPEED_ON_PLAYER_DETECTED)
		var selfPos=self.get_global_position()
		if int(lastPlayerPos.x/100)!=int(selfPos.x/100) or int(lastPlayerPos.y/100)!=int(selfPos.y/100):
			print(lastPlayerPos.x)
			print(lastPlayerPos.y)
			print(self.get_global_position().x)
			print(self.get_global_position().y)
			print("------------------------")
			vehicle.make_turn(Vector2(0,0))	 #run forwand until we loose the player
		else:
			following=false
		
func _on_Vehicle_moving(movement):
	  position = position + movement

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

