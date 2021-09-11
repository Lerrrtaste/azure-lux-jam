extends TileMap


const House = preload("res://objects/house/house.tscn")
onready var pos_player_spawn = $PosPlayerSpawn

func _ready():
	_spawn_buildings()

func _spawn_buildings()->void:
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
	vehicle.connect("request_new_target",self,"_on_Vehicle_request_new_target")
	print(vehicle, ": Registered in city. Can now drive and navigate.")

func _on_Vehicle_request_new_target(vehicle:VehicleClass, turn_vector:Vector2)->void:
	var cell_current := world_to_map(vehicle.global_position)
	var cell_requested_coord := cell_current + turn_vector.normalized()
	var cell_requested_id := get_cellv(cell_requested_coord)

	if cell_requested_id == INVALID_CELL:
		return
	
	var shapes = tile_set.tile_get_shapes(cell_requested_id)
	for i in shapes:
		if i.has("shape"):
			return
	
	var target_position := map_to_world(cell_requested_coord) + cell_size/2
	vehicle.allow_distance(cell_size.x)

func _get_player_spawn()->Vector2:
	var cell := world_to_map(pos_player_spawn)
	return map_to_world(cell)+cell_size/2
