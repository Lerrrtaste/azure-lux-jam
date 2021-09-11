extends TileMap


func _ready():
	pass # Replace with function body.

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
