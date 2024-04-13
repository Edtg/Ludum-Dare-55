extends Node3D


@export var radius: float = 1.0
@export var starting_amount: int = 1
@export var rock_scene: PackedScene


func _ready():
	GameManager.spawn_rocks.connect(spawn_rocks)
	spawn_rocks(starting_amount)


func spawn_rocks(extra_rocks: int):
	var amount = starting_amount + extra_rocks
	for i in range(amount):
		var rock = rock_scene.instantiate()
		var pos = Vector2.from_angle(randf() * 2 * PI) * randf_range(0.1, radius)
		rock.position = Vector3(pos.x, 0, pos.y)
		add_child(rock)
