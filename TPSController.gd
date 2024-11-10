extends CharacterBody3D

class_name TPSController

@export var gravity := 0.5
@export var speed := 10
@export var sensibility := 1
@onready var camera: SpringArm3D = $SpringArm3D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func moveCamera(movement: Vector2) -> void:
	camera.rotation.y -= movement.x / 1000
	camera.rotation.x -= movement.y / 1000
	camera.rotation *= sensibility
	camera.rotation.x = clamp(camera.rotation.x, -1, 0.8)

func handleMovement(delta: float) -> void:
	if !is_on_floor():
		velocity.y -= gravity * delta
	var input := Input.get_vector("left", "right", "forward", "backward",)
	var direction := (camera.global_transform.basis * Vector3(input.x, 0, input.y)).normalized()
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	move_and_slide()

func handleControllerCamera() -> void:
	var direction := Input.get_vector("look_left", "look_right", "look_up", "look_down")
	direction *= 50
	moveCamera(direction)

func _physics_process(delta: float) -> void:
	handleControllerCamera()
	handleMovement(delta)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		moveCamera(event.relative)
