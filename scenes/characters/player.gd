extends CharacterBody3D

signal upgrade_confirmed

const MOVE_SPEED: float = 4.0
const SLIDE_SPEED: float = 8.0
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var can_move: bool = true
var direction
var is_sliding: bool

var upgraded_speed: float
var speed_upgrade_amount: float = 0.5
var upgraded_slide_speed: float
var slide_upgrade_amount: float = 0.4
var carrying_upgrade_amount: int = 1

var rock_count: int
var max_rocks: int = 2

@onready var rock_counter = $HUD/RockCounter
@onready var upgrade_menu = $HUD/UpgradeMenu
@onready var movement_animation = $MovementAnimation
@onready var pivot = $Pivot


func _ready():
	upgrade_menu.upgrade_confirmed.connect(_on_upgrade_confirmed)
	upgrade_menu.speed_upgraded.connect(_on_speed_upgraded)
	upgrade_menu.slide_upgraded.connect(_on_slide_upgraded)
	upgrade_menu.carrying_upgraded.connect(_on_carrying_upgraded)


func _physics_process(delta):
	if is_on_floor():
		velocity.y = 0
	else:
		velocity.y -= gravity * delta
	
	if Input.is_action_just_pressed("slide") and velocity.length() >= MOVE_SPEED:
		is_sliding = true
		pivot.rotation.x = -90
		velocity.x = direction.x * (SLIDE_SPEED + upgraded_slide_speed)
		velocity.z = direction.z * (SLIDE_SPEED + upgraded_slide_speed)
	
	if Input.is_action_just_released("slide"):
		is_sliding = false
		pivot.rotation.x = 0
	
	var input_direction = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	
	if input_direction and not is_sliding:
		direction = (transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
	var speed = MOVE_SPEED + upgraded_speed
	
	if is_sliding:
		velocity.x = move_toward(velocity.x, 0, 0.1)
		velocity.z = move_toward(velocity.z, 0, 0.1)
		pivot.rotation.y = lerp_angle(pivot.rotation.y, atan2(-direction.x, -direction.z), delta * 10)
	elif input_direction and can_move:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		pivot.rotation.y = lerp_angle(pivot.rotation.y, atan2(-direction.x, -direction.z), delta * 10)
		
		movement_animation.play("walk_loop")
	else:
		velocity.x = move_toward(velocity.x, 0, 0.5)
		velocity.z = move_toward(velocity.z, 0, 0.5)
		movement_animation.stop()
	
	move_and_slide()


func pickup_rock():
	rock_count += 1
	update_hud()


func can_pickup_rock() -> bool:
	return rock_count < max_rocks


func deposit_rocks():
	rock_count = 0
	update_hud()


func update_hud():
	rock_counter.text = str(rock_count)


func show_upgrade_menu():
	can_move = false
	upgrade_menu.show()


func _on_upgrade_confirmed():
	can_move = true
	upgrade_menu.hide()
	upgrade_confirmed.emit()


func _on_speed_upgraded():
	upgraded_speed += speed_upgrade_amount


func _on_slide_upgraded():
	upgraded_slide_speed += slide_upgrade_amount


func _on_carrying_upgraded():
	max_rocks += carrying_upgrade_amount
