extends Node2D

var  visionRange:=g.ENEMY_ZOMBIE_VISION_RANGE
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var vehicle:= $EnemyBase/Vehicle
onready var enemyBase:=$EnemyBase
onready var rayCastFront:= $RayCastFront
onready var rayCastBack:= $RayCastBack
var lastPlayerPos:=Vector2(0,0)
var following:=false
var spawed:=false
var timeout:float
var strength:=-1.0
var frontPlayer:bool


# Called when the node enters the scene tree for the first time.
func _ready():
	assert(strength>=0.0 && strength<=1.0 )
	#make zombie capable according to its strengh
	enemyBase.damage_impact=int(strength*3*g.ENEMY_ZOMBIE_DAMAGE)
	enemyBase.attack_damage=int(strength*3*g.ENEMY_ZOMBIE_DAMAGE)
	enemyBase.player_slowdown_percent=strength/2
	enemyBase.attack_cooldown=1/(strength*2)
	enemyBase.attack_range=int(strength*36)
	enemyBase.slowdown_range=int(strength*96)
	enemyBase.body_radius=int(4/strength)
	vehicle.set_speed_modifier(g.ENEMY_ZOMBIE_DEFAULT_SPEED) #set deafult spped of the zombie
	$EnemyBase.damage_impact=g.ENEMY_ZOMBIE_DAMAGE #set damage to enemy base
	$EnemyBase.attack_cooldown=g.ENEMY_ZOMBIE_ATTACK_COOLDOWN
	vehicle.connect("end_reached",self,"_on_Vehicle_end_reached")
	vehicle.connect("moving", self, "_on_Vehicle_moving")

func _draw():
	if following : #draw the circle according to the following status
		draw_circle(Vector2(), 18, ColorN("red", 0.3))
	
	
func _process(delta):
		var collider
		if rayCastFront.is_colliding() and rayCastFront.get_collider().get_parent().is_in_group("Players") :
			collider=rayCastFront.get_collider().get_parent()
			frontPlayer=true
		elif rayCastBack.is_colliding() and rayCastBack.get_collider().get_parent().is_in_group("Players") :
			collider=rayCastBack.get_collider().get_parent()
			frontPlayer=false
		else :
			timeout+=delta	#after 10 seconds stop trying to catch up with the player
			if(timeout>g.ENEMY_ZOMBIE_FOLLOWING_TIMEOUT) :
				following=false
			return
		lastPlayerPos=collider.get_global_position()
		following=true
		timeout=0



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
			rayCastFront.cast_to=tmp
			tmp.x=tmp.x/-g.ENEMY_ZOMBIE_VISION_BACK_DIVISOR #the vison range on the back in only athird the front an in the other direction
			tmp.y=tmp.y/-g.ENEMY_ZOMBIE_VISION_BACK_DIVISOR
			rayCastBack.cast_to=tmp
			
	else:
		vehicle.set_speed_modifier(g.ENEMY_ZOMBIE_SPEED_ON_PLAYER_DETECTED)
		if !frontPlayer : #player is at back
			vehicle.turn_around() # turn around
			var tmp5=rayCastFront.cast_to #swap raycast front an back vectors (baecause we turned around)
			rayCastFront.cast_to=rayCastBack.cast_to
			rayCastBack.cast_to=tmp5
		var selfPos=self.get_global_position()
		var precision=70 #how accorate need the players last position an dthe zombies position need to match
		if int(lastPlayerPos.x/precision)!=int(selfPos.x/precision) or int(lastPlayerPos.y/precision)!=int(selfPos.y/precision):
			print(int(lastPlayerPos.x/precision))
			print(int(lastPlayerPos.y/precision))
			print(int(self.get_global_position().x/precision))
			print(int(self.get_global_position().y/precision))
			print("------------------------")
			vehicle.make_turn(Vector2(0,0))	 #run forwand until we loose the player
		else:
			following=false
		
func _on_Vehicle_moving(movement):
	  position = position + movement

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

