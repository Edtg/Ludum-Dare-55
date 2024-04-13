extends CharacterBody3D

const MOVE_SPEED: float = 4.0
const SPRINT_SPEED: float = 6.0
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


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
	else:
		velocity.x = move_toward(velocity.x, 0, 0.5)
		velocity.z = move_toward(velocity.z, 0, 0.5)
	
	move_and_slide()