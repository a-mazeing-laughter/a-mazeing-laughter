extends Node3D

var levelNode;
var currentLevel = -1
@onready var levels = [
	preload("res://scenes/levels/level-1.tscn"),
	preload("res://scenes/levels/level-2.tscn"),
	preload("res://scenes/levels/level-3.tscn"),
	preload("res://scenes/levels/level-4.tscn"),
	preload("res://scenes/levels/level-5.tscn"),
	preload("res://scenes/levels/level-6.tscn"),
]

@onready var smileSound : AudioStreamPlayer = get_node("BackgroundMusic/smileSound")
@onready var lmaoSounds = [
	preload("res://assets/sounds/lmao1.wav"),
	preload("res://assets/sounds/lmao2.wav"),
	preload("res://assets/sounds/lmao3.wav"),
	preload("res://assets/sounds/lmao4.wav"),
]

@onready var player = get_node("Sphere")
@onready var spatial : Node3D = get_node("Sphere/Spatial")
@onready var camera : Camera3D = get_node("Sphere/Spatial/Camera3D")
@onready var boundary = get_node("WorldBoundary")
@onready var laughometer = get_node("Laughometer")

@onready var initialPlayerPosition = player.position

var initialCameraRotation = deg_to_rad(-70.0)
var maxRotation = 0.3
var inputVector

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	laughometer.value = 30
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
		var endScene = preload("res://scenes/main/end.tscn").instantiate()
		get_tree().root.add_child(endScene)
		endScene.get_node("EndText").text = "
			 YOU WON!
	 Laughometer left: " + str(laughometer.value) + "

		Press R to restart"
		get_tree().paused = true
		currentLevel = 0

	levelNode = levels[currentLevel].instantiate()
	add_child(levelNode)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	inputVector = getInputVector()

func _physics_process(delta):
	var acceleration = delta * 1000
	player.apply_force(inputVector * acceleration)

	adjustRotation(delta)

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
	spatial.position = player.position
	var diff = delta * 0.5

	if inputVector.x == 0:
		spatial.rotation.z = lerp(spatial.rotation.z, 0.0, diff)
	else:
		spatial.rotation.z = clamp(spatial.rotation.z + (diff * inputVector.x), -maxRotation, maxRotation)

	if inputVector.z == 0:
		spatial.rotation.x = lerp(spatial.rotation.x, 0.0, diff)
	else:
		spatial.rotation.x = clamp(spatial.rotation.x + (diff * -inputVector.z), -maxRotation, maxRotation)


func game_over():
	var endScene = preload("res://scenes/main/end.tscn").instantiate()
	get_tree().root.add_child(endScene)
	endScene.get_node("EndText").text = "
		 YOU LOOSE!
	Press R to restart"
	get_tree().paused = true

func _on_sphere_body_entered(body):
	if body == boundary:
		# YOU LOSE
		game_over()

	if body.is_in_group("collectibles"):
		body.get_parent().remove_child(body)
		body.queue_free()

		if body.name == "Goal":
			next_level()
		elif body.is_in_group("booster"):
			player.apply_impulse(Vector3.FORWARD * 30)
		elif body.is_in_group("avoidables"):
			laughometer.value -= 5
		else:
			laughometer.value += 5
			smileSound.stream = lmaoSounds[randi_range(0, lmaoSounds.size() - 1)]
			smileSound.play()

func _on_game_over_timer_timeout():
	laughometer.value -= 1;

	if laughometer.value <= 0:
		game_over()

