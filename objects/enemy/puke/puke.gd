extends Node2D

onready var timer_despawn = $TimerDespawn

export(int) var lifetime = 5

func _ready():
	timer_despawn.connect("timeout",self,"_on_TimerDespawn_timeout")
	timer_despawn.start(lifetime)

func _on_TimerDespawn_timeout()->void:
	visible = false
	set_process(false)
	queue_free()
