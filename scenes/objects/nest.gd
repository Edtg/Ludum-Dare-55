extends Node3D


var rock_count: int

@export var required_rocks: int = 5

@onready var penguin_spirit = $PenguinSpirit


func _on_proximity_detector_body_entered(body):
	if body.is_in_group("penguins"):
		rock_count += body.rock_count
		body.deposit_rocks()
		check_rock_count()


func check_rock_count():
	if rock_count >= required_rocks:
		rock_count -= required_rocks
		penguin_spirit.show()
