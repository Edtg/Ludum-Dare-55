extends Node


@export var map: PackedScene
@export var nest_positions: Array[Vector3]

const NEST = preload("res://scenes/objects/nest.tscn")
const PLAYER = preload("res://scenes/characters/player.tscn")

func _ready():
	setup_map()


func setup_map():
	var new_map = map.instantiate()
	add_child(new_map)
	for p in nest_positions:
		var new_nest = NEST.instantiate()
		new_nest.position = p
		if p == nest_positions[0]:
			var player = PLAYER.instantiate()
			player.position = p
			new_nest.assigned_penguin = player
			new_map.add_child(player)
		else:
			# Spawn enemy
			pass
		
		new_map.add_child(new_nest)