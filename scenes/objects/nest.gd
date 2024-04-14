extends Node3D


const ROCK_PICKUP = preload("res://scenes/objects/rock_pickup.tscn")

var rock_count: int
var deposited_rocks: Array[Node3D]

@export var assigned_penguin: CharacterBody3D
@export var required_rocks: int = 5
@export var required_rocks_increase: int = 3

@onready var penguin_spirit = $PenguinSpirit


func _ready():
	if is_instance_valid(assigned_penguin):
		assigned_penguin.upgrade_confirmed.connect(_on_upgrade_confirmed)


func _on_proximity_detector_body_entered(body):
	if body == assigned_penguin:
		rock_count += body.rock_count
		for i in body.rock_count:
			var rock = ROCK_PICKUP.instantiate()
			rock.owning_penguin = assigned_penguin
			var pos = Vector2.from_angle(randf() * 2 * PI) * randf_range(0.1, 1.4)
			rock.position = Vector3(pos.x, 0, pos.y)
			deposited_rocks.append(rock)
			add_child(rock)
		body.deposit_rocks(rock_count, required_rocks)
		check_rock_count()


func check_rock_count():
	if rock_count >= required_rocks:
		rock_count -= required_rocks
		for i in range(required_rocks):
			var rock = deposited_rocks[i]
			rock.queue_free()
		
		for i in range(required_rocks):
			deposited_rocks.pop_front()
		required_rocks += required_rocks_increase
		penguin_spirit.show()
		assigned_penguin.get_upgrade(rock_count, required_rocks)
		GameManager.spirit_summoned(required_rocks)


func _on_upgrade_confirmed():
	penguin_spirit.hide()
