extends Control

var score := 0
var money := 0

onready var city := $City
onready var player := $City/Player

func _ready():
	player.position = city._get_player_spawn()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
