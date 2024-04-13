extends Node3D


func _on_proiximity_detector_body_entered(body):
	if body.is_in_group("penguins"):
		if body.can_pickup_rock():
			body.pickup_rock()
			queue_free()
