extends Node3D

var levelNode;
var currentLevel = -1
@onready var levels = [
	preload("res://scenes/levels/level-1.tscn"),
	preload("res://scenes/levels/level-2.tscn")
]

@onready var player = get_node("Sphere")
@onready var camera : Camera3D = get_node("Camera3D")
@onready var boundary = get_node("WorldBoundary")

@onready var initialPlayerPosition = player.position

var initialCameraRotation = deg_to_rad(-70.0)
var maxRotation = 0.3
var inputVector

# Called when the node enters the scene tree for the first time.
func _ready():
	next_level()

func next_level():
	if levelNode:
		remove_child(levelNode)
		levelNode.queue_free()
		
		player.set_linear_velocity(Vector3(0,0,0))
		player.position = initialPlayerPosition
		
	inputVector = Vector3()

	currentLevel += 1
	
	if currentLevel >= levels.size():
		currentLevel = 0
	
	levelNode = levels[currentLevel].instantiate()
	add_child(levelNode)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	inputVector = getInputVector()

func _physics_process(delta):
	adjustRotation(delta)
	follow_camera()

func follow_camera():
	camera.position.x = player.position.x
	camera.position.z = player.position.z + 10

func getInputVector():
	var vector = Vector3()
	
	vector.x = Input.get_gyroscope().x
	vector.z = Input.get_gyroscope().y

	if Input.is_action_pressed("ui_left"):
		vector.x = -1
	elif Input.is_action_pressed("ui_right"):
		vector.x = 1

	if Input.is_action_pressed("ui_up"):
		vector.z = -1
	elif Input.is_action_pressed("ui_down"):
		vector.z = 1

	return vector

func adjustRotation(delta):
	var acceleration = delta * 1000
	player.apply_force(inputVector * acceleration)

	var diff = delta * 0.1

	if inputVector.x == 0:
		camera.rotation.y = lerp(camera.rotation.y, 0.0, diff * 6)
		camera.rotation.z = camera.rotation.y * -1
	else:
		camera.rotation.y = clamp(camera.rotation.y + (diff * -6 * inputVector.x), -maxRotation, maxRotation)
		camera.rotation.z = camera.rotation.y * -1

	if inputVector.z == 0:
		camera.rotation.x = lerp(camera.rotation.x, initialCameraRotation, diff)
	else:
		camera.rotation.x = clamp(camera.rotation.x + (diff * -1 * inputVector.z), initialCameraRotation - maxRotation, initialCameraRotation + maxRotation)

func _on_sphere_body_entered(body):
	if body == boundary:
		# YOU LOSE
		var loosingScene = preload("res://scenes/main/loose.tscn").instantiate()
		get_tree().root.add_child(loosingScene)
		get_tree().paused = true
	
	if body.is_in_group("collectibles"):
		body.get_parent().remove_child(body)
		body.queue_free()
		
		if body.name == "Goal":
			next_level()
