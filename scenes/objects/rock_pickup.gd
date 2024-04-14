extends Node3D

@export var random_scale_min: float = 0.8
@export var random_scale_max: float = 1.4

@onready var rock_mesh = $RockMesh


func _ready():
	var rock_scale = randf_range(random_scale_min, random_scale_max)
	rock_mesh.scale = Vector3(rock_scale, rock_scale, rock_scale)


func _on_proiximity_detector_body_entered(body):
	if body.is_in_group("penguins"):
		if body.can_pickup_rock():
			body.pickup_rock()
			queue_free()
