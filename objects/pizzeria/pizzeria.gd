extends Node2D

onready var tween = $Tween
onready var marker_template = $MarkerTemplate
var markers := []

var pizzas_ready=0

signal player_picking_up

#draw the pizza ready marker
func _draw():
	if pizzas_ready>0:
		pass#draw_circle(Vector2(), 50, ColorN("yellow", 0.2))

func _ready():
	pass#marker.visible=false #no function atm

func notifyNewPizza():
	pizzas_ready+=1
	var strm = $AudioStreamPlayer.stream as AudioStreamMP3
	strm.set_loop(false)
	$AudioStreamPlayer.play()
	
	
	var inst = marker_template.duplicate()
	inst.visible=true
	add_child(inst)
	inst.position.y -= markers.size()*inst.texture.get_height()/inst.vframes*0.8
	markers.append(inst)
	tween.interpolate_property(inst,"scale",Vector2(),Vector2(1.5,1.5),1.0,Tween.TRANS_ELASTIC,Tween.EASE_OUT)
	tween.interpolate_property(inst,"scale",Vector2(1.5,1.5),Vector2(1,1),5.0,Tween.TRANS_BACK,Tween.EASE_OUT,1.1)
	tween.start()
	

func notifyRemovedPizza():
	pizzas_ready-=1
	var del = markers.pop_back()
	del.visible = false
	del.queue_free()

func _process(delta):
	update()

func _on_Area2D_area_entered(area):
	emit_signal("player_picking_up")




