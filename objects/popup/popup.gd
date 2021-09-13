extends Node2D

onready var tween = $Tween
onready var label = $LblText

enum Phase {
	NONE = -1,
	GROWING,
	MOVING
}
var phase:int = Phase.NONE

var to:Vector2

func _ready():
	rotate(deg2rad(randi()%50-25))
	tween.connect("tween_all_completed",self,"_on_Tween_all_completed")

func start(text:String,from:Vector2,to:Vector2)->void:
	label.text = text
	position = from
	self.to = to
	_switch_phase(Phase.GROWING)

func _switch_phase(val:int)->void:
	phase = val
	match phase:
		Phase.GROWING:
			var duration = 0.4
			tween.interpolate_property(self,"position",null,Vector2(position.x+randi()%100-50,position.y-50),duration,Tween.TRANS_CIRC,Tween.EASE_OUT)
			tween.interpolate_property(self,"modulate.a",0.0,1.0,duration,Tween.TRANS_LINEAR,2)
			tween.interpolate_property(self,"scale",Vector2(0.1,0.1),Vector2(1.0,1.0),duration,Tween.TRANS_CIRC,Tween.EASE_OUT)
			tween.start()
		Phase.MOVING:
			tween.interpolate_property(self,"position",null,to,0.5,Tween.TRANS_BACK,Tween.EASE_IN)
			tween.start()
		_:
			set_process(false)
			visible = false
			queue_free()

func _on_Tween_all_completed()->void:
	_switch_phase(phase+1)
