extends Node2D

onready var timer_despawn = $TimerDespawn
onready var enemy_base = $EnemyBase

export(int) var lifetime = 5

func _ready():
	enemy_base.player_slowdown_percent = g.ENEMY_PUKE_SLOWDOWN_PERCENT
	enemy_base.damage_impact = g.ENEMY_PUKE_DAMAGE_IMPACT
	
	timer_despawn.connect("timeout",self,"_on_TimerDespawn_timeout")
	timer_despawn.start(g.ENEMY_PUKE_LIFETIME)
	var strm = $AudioStreamPlayer.stream as AudioStreamMP3
	strm.set_loop(false)
	$AudioStreamPlayer.play()

func _on_TimerDespawn_timeout()->void:
	visible = false
	set_process(false)
	queue_free()
