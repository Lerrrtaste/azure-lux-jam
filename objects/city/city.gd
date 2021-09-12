extends TileMap


const House = preload("res://objects/house/house.tscn")

onready var pos_player_spawn = $PosPlayerSpawn
onready var pos_pizzeria = $PosPizzeria
onready var pizzeria = $Pizzeria

func _ready():
	_spawn_buildings()

func _spawn_buildings()->void:
	#pizzeria
	pizzeria.position = map_to_world(world_to_map(pos_pizzeria.position))+cell_size
	
	#houses
	for i in get_used_cells():
		var cell_id  = get_cellv(i)
		match tile_set.tile_get_name(cell_id):
			"house":
				var inst = House.instance()
				
				var street_direction = -1
				var cell_id_street := tile_set.find_tile_by_name("street")
				if get_cellv(i+Vector2(0,-1)) == cell_id_street:
					street_direction = inst.directions.UP
				if get_cellv(i+Vector2(-1,0)) == cell_id_street:
					street_direction = inst.directions.LEFT
				if get_cellv(i+Vector2(1,0)) == cell_id_street:
					street_direction = inst.directions.RIGHT
				if get_cellv(i+Vector2(0,1)) == cell_id_street:
					street_direction = inst.directions.DOWN
				
				if street_direction == -1:
					printerr(inst.name + " konnte kein Strasse finden!")
					continue
				
				inst.position = map_to_world(i) + cell_size/2
				inst.set_direction(street_direction)
				add_child(inst)

#required signals for driving
func register_vehicle(vehicle:VehicleClass)->void:
	vehicle.connect("update_possible_directions",self,"_on_Vehicle_update_possible_directions")
	print(vehicle.name, ": Registered in city. Can now drive and navigate.")


func _on_Vehicle_update_possible_directions(vehicle:VehicleClass)->void:
#	var cell_current := world_to_map(vehicle.global_position-self.position)
#	#var cell_requested_coord := cell_current + turn_vector.normalized()
#	var cell_requested_id := get_cellv(cell_requested_coord)
#
#	if cell_requested_id == INVALID_CELL:
#		return
#
#	var shapes = tile_set.tile_get_shapes(cell_requested_id)
#	for i in shapes:
#		if i.has("shape"):
#			return
#
#	var target_position := map_to_world(cell_requested_coord) + cell_size/2
#	vehicle.allow_distance(cell_size.x)

	var cell_current := world_to_map(vehicle.global_position-self.position)
	var ret_possible_directions:Array
	
	#test all adjacent cells for collision shapes
	for dir in range(4):
		var test_turn :=  Vector2()
		match dir:
			0: #up
				test_turn.y = -1
			1: #right
				test_turn.x = 1
			2: #down
				test_turn.y = 1
			3: #left
				test_turn.x = -1
		
		var cell_test := cell_current+test_turn
		var cell_test_id := get_cellv(cell_test)
		
		if cell_test_id == INVALID_CELL:
			continue
		
		if tile_set.tile_get_shapes(cell_test_id).empty(): #no collision shape
			ret_possible_directions.append(test_turn)
	
	vehicle.set_possible_directions(ret_possible_directions)
	
	

func _get_player_spawn()->Vector2:
	var cell := world_to_map(pos_player_spawn.position)
	return map_to_world(cell)+cell_size/2

func get_cell_center_pos(approx_pos:Vector2)->Vector2:
	var cell := world_to_map(approx_pos)
	return map_to_world(cell)+cell_size/2
