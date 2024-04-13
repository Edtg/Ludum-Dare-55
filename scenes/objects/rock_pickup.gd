extends Node3D


func _on_proiximity_detector_body_entered(body):
	if body.is_in_group("penguins"):
		body.pickup_rock()
		queue_free()
