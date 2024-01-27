extends Node3D

var levelNode;
var currentLevel = -1
@onready var levels = [
	preload("res://scenes/levels/level-1.tscn")
]

@onready var player = get_node("Sphere")
@onready var camera : Camera3D = get_node("Camera3D")
@onready var boundary = get_node("WorldBoundary")

var loosingScene = preload("res://scenes/main/loose.tscn").instantiate()

var maxRotation = 0.3
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
	var camRotation = delta * 0.75

	player.apply_force(inputVector * acceleration)

func _on_sphere_body_entered(body):
	if body == boundary:
		# YOU LOSE
		get_tree().root.add_child(loosingScene)
		get_tree().paused = true
	
	if body.is_in_group("collectibles"):
		body.get_parent().remove_child(body)
		body.queue_free()
