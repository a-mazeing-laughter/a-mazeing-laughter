extends Node3D

var levelNode;
var currentLevel = -1
@onready var levels = [
	preload("res://scenes/levels/level-1.tscn")
]

@onready var player = get_node("Sphere")

var maxRotation = 0.3
var rotationSpeed = 0.75
var inputVector = Vector3()

# Called when the node enters the scene tree for the first time.
func _ready():
	next_level()

func next_level():
	if levelNode:
		remove_child(levelNode)
		levelNode.queue_free()

	currentLevel += 1
	levelNode = levels[currentLevel].instantiate()
	add_child(levelNode)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	inputVector = getInputVector()

func _physics_process(delta):
	adjustRotation(delta)

func getInputVector():
	if check_lose():
		# YOU LOSE!
		return

	var vector = Vector3()

	if Input.is_action_pressed("ui_left"):
		vector.z = 1
	elif Input.is_action_pressed("ui_right"):
		vector.z = -1

	if Input.is_action_pressed("ui_up"):
		vector.x = -1
	elif Input.is_action_pressed("ui_down"):
		vector.x = 1

	return vector

func adjustRotation(delta):
	var diff = delta * rotationSpeed

	if inputVector.x == 0:
		levelNode.rotation.x = lerp(levelNode.rotation.x, 0.0, diff)
	else:
		levelNode.rotation.x = clamp(levelNode.rotation.x + (diff * inputVector.x), -maxRotation, maxRotation)

	if inputVector.z == 0:
		levelNode.rotation.z = lerp(levelNode.rotation.z, 0.0, diff)
	else:
		levelNode.rotation.z = clamp(levelNode.rotation.z + (diff * inputVector.z), -maxRotation, maxRotation)

func check_lose():
	var sphereY = player.position.y;
	return sphereY <= -50
