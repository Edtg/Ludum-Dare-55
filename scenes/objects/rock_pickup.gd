extends Node3D

signal rock_collected(rock: Node3D)

@export var random_scale_min: float = 0.8
@export var random_scale_max: float = 1.4

var owning_penguin: CharacterBody3D

@onready var rock_mesh = $RockMesh


func _ready():
	var rock_scale = randf_range(random_scale_min, random_scale_max)
	rock_mesh.scale = Vector3(rock_scale, rock_scale, rock_scale)
	rock_mesh.rotation.y = randf_range(0, 360)


func _on_proiximity_detector_body_entered(body):
	if body.is_in_group("penguins") and body != owning_penguin:
		if body.can_pickup_rock():
			body.pickup_rock()
			rock_collected.emit(self)
			queue_free()
