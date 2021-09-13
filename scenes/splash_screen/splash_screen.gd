extends Node2D

onready var anim_player := $AnimationPlayer

func _ready():
	anim_player.play("SplashAnimation")


func _on_AcceptDialog_confirmed():
	get_tree().change_scene("res://scenes/game/Game.tscn")


func _on_AnimationPlayer_animation_finished(anim_name):
	$AcceptDialog.popup_centered()


func _on_AcceptDialog_popup_hide():
	_on_AcceptDialog_confirmed()
