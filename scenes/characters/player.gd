extends CharacterBody3D

signal upgrade_confirmed

const MOVE_SPEED: float = 4.0
const SPRINT_SPEED: float = 6.0
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var rock_count: int
var max_rocks: int = 2

@onready var rock_counter = $HUD/RockCounter
@onready var upgrade_menu = $HUD/UpgradeMenu
@onready var movement_animation = $MovementAnimation
@onready var pivot = $Pivot


func _ready():
	upgrade_menu.upgrade_confirmed.connect(_on_upgrade_confirmed)


func _physics_process(delta):
	if is_on_floor():
		velocity.y = 0
	else:
		velocity.y -= gravity * delta
	
	
	var input_direction = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	
	var direction = (transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
	var speed = MOVE_SPEED
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	
	if direction:
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
	upgrade_menu.show()


func _on_upgrade_confirmed():
	upgrade_menu.hide()
	upgrade_confirmed.emit()
