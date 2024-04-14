extends CharacterBody3D

signal upgrade_confirmed

const MOVE_SPEED: float = 4.0
const SLIDE_BOOST_BASE: float = 2.0
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var target_rock: Node3D
var nest_location: Vector3

var rock_count: int
var max_rocks: int = 2

var is_upgrading: bool

var speed_level: int
var slide_level: int
var carrying_level: int

var speed_upgrade_amount: float = 0.5
var slide_upgrade_amount: float = 0.8
var carrying_upgrade_amount: int = 1

@onready var nav_agent = $NavigationAgent3D
@onready var upgrade_timer = $UpgradeTimer


func _physics_process(delta):
	if is_upgrading:
		return
	
	var target_location: Vector3
	if rock_count < max_rocks:
		target_rock = get_closest_rock()
		target_location = target_rock.global_position
	else:
		target_location = nest_location
	
	nav_agent.target_position = target_location
	if nav_agent.is_target_reachable():
		var current_position = global_transform.origin
		var next_position = nav_agent.get_next_path_position()
		var new_direction = (next_position - current_position).normalized()
		
		var speed = MOVE_SPEED + (speed_level * speed_upgrade_amount)
		
		velocity = velocity.move_toward(new_direction * speed, 0.25)
		
		move_and_slide()


func get_closest_rock() -> Node3D:
	var rock = get_tree().get_nodes_in_group("rocks")[0]
	return rock


func pickup_rock():
	rock_count += 1


func can_pickup_rock() -> bool:
	return rock_count < max_rocks


func deposit_rocks(rocks_deposited: int, rocks_required: int):
	rock_count = 0


func get_upgrade(rocks_deposited: int, new_required_rocks: int):
	is_upgrading = true
	upgrade_timer.start()
	apply_best_upgrade()


func _on_upgrade_timer_timeout():
	is_upgrading = false
	upgrade_confirmed.emit()


func apply_best_upgrade():
	var skill = randi_range(0, 2)
	
	if skill == 0:
		# Level up speed
		speed_level += 1
	elif skill == 1:
		# Level up slide
		slide_level += 1
	elif skill == 2:
		# Level up carrying
		carrying_level += 1
		max_rocks += carrying_upgrade_amount
