extends CharacterBody3D

signal upgrade_confirmed

const MOVE_SPEED: float = 4.0
const SLIDE_BOOST_BASE: float = 2.0
const NAV_Y_OFFSET: float = 0.25
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var target_rock: Node3D
var nest_location: Vector3

var direction: Vector3

var is_sliding: bool
var can_slide: bool = true

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
@onready var pivot = $Pivot
@onready var slide_cooldown = $SlideCooldown
@onready var anim_player = $AnimationPlayer


func _physics_process(delta):
	if is_upgrading:
		return
	
	var target_location: Vector3
	if rock_count < max_rocks:
		target_rock = get_closest_rock()
		target_location = target_rock.global_position
		while not nav_agent.is_target_reachable():
			target_rock = get_closest_rock()
			target_location = target_rock.global_position
	else:
		target_location = nest_location
	
	nav_agent.target_position = target_location
	if nav_agent.is_target_reachable():
		var current_position = global_transform.origin
		var next_position = nav_agent.get_next_path_position()
		next_position.y = next_position.y - NAV_Y_OFFSET
		if not is_sliding:
			direction = (next_position - current_position).normalized()
		
		if current_position.distance_to(next_position) <= 2.0 and not is_sliding:
			is_sliding = true
			velocity = direction * (MOVE_SPEED + (speed_level * speed_upgrade_amount) + (slide_level * slide_upgrade_amount))
			pivot.rotation.x = -90
		
		pivot.rotation.y = lerp_angle(pivot.rotation.y, atan2(-direction.x, -direction.z), delta * 10)
		
		if is_sliding:
			velocity = velocity.move_toward(Vector3.ZERO, 0.1)
			if velocity.length() <= 1.0:
				is_sliding = false
				pivot.rotation.x = 0
		else:
			var speed = MOVE_SPEED + (speed_level * speed_upgrade_amount)
			velocity = velocity.move_toward(direction * speed, 0.25)
		
		if velocity.length() > 0:
			anim_player.play("walk_loop")
		else:
			anim_player.stop()


func get_closest_rock() -> Node3D:
	var rocks = get_tree().get_nodes_in_group("rocks")
	var closest = rocks[0]
	var closest_distance_squared = global_position.distance_squared_to(closest.global_position)
	for r in rocks:
		if r.owning_penguin == self:
			continue
		var distance_squared = global_position.distance_squared_to(r.global_position)
		if distance_squared < closest_distance_squared:
			closest = r
	return closest


func pickup_rock():
	rock_count += 1


func can_pickup_rock() -> bool:
	return rock_count < max_rocks


func deposit_rocks():
	rock_count = 0


func get_upgrade():
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


func _on_slide_cooldown_timeout():
	can_slide = true


func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	if not is_upgrading and nav_agent.is_target_reachable():
		move_and_slide()
