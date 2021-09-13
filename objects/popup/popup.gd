extends Node2D

onready var tween = $Tween
onready var label = $LblText

var phase:int = 0
var inplace:bool

var to:Vector2

func _ready():
	rotation_degrees = randi()%10-5
	tween.connect("tween_all_completed",self,"_on_Tween_all_completed")

func start(text:String,from:Vector2,to:Vector2)->void:
	inplace = (from == to)
	label.text = text
	position = from
	self.to = to +(Vector2(0,-24) if inplace else Vector2())
	
	_switch_phase(1)

func _switch_phase(val:int)->void:
	phase = val
	match phase:
		1:
			var duration = 0.5
			tween.interpolate_property(self,"position",null,Vector2(position.x+randi()%10-5,position.y-50),duration,Tween.TRANS_CIRC,Tween.EASE_OUT)
			tween.interpolate_property(label,"modulate",ColorN("white",0.0),ColorN("white",1.0),duration/2,Tween.TRANS_LINEAR)
			tween.interpolate_property(self,"scale",Vector2(0.1,0.1),Vector2(1.0,1.0),duration,Tween.TRANS_CIRC,Tween.EASE_OUT)
			tween.start()
		2:
			if inplace:
				#tween.interpolate_property(label,"modulate.a",1.0,0.0,0.4,Tween.TRANS_LINEAR,Tween.EASE_IN,0.1)
				tween.interpolate_property(label,"modulate",ColorN("white",1.0),ColorN("white",0.0),0.5,Tween.TRANS_LINEAR,Tween.EASE_IN,0.5)
			else:
				tween.interpolate_property(self,"position",null,to,0.4,Tween.TRANS_BACK,Tween.EASE_IN,0.1)
			tween.start()
		_:
			set_process(false)
			visible = false
			queue_free()

func _on_Tween_all_completed()->void:
	_switch_phase(phase+1)
