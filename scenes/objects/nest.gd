extends Node3D


var rock_count: int

func _on_proximity_detector_body_entered(body):
	if body.is_in_group("penguins"):
		rock_count = body.rock_count
		body.deposit_rocks()
