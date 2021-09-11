extends TileMap


func _ready():
	pass # Replace with function body.

#required signals for driving
func register_vehicle(vehicle:VehicleClass)->void:
	vehicle.connect("request_new_target",self,"_on_Vehicle_request_new_target")

func _on_Vehicle_request_new_target()->void:
	pass
