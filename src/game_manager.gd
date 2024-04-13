extends Node

signal spawn_rocks(rocks_used: int)

func spirit_summoned(rocks_used: int):
	spawn_rocks.emit(rocks_used)
