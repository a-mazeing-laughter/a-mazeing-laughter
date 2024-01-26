extends Node3D

var levelNode;
var currentLevel = -1
@onready var levels = [
	preload("res://scenes/levels/level-1.tscn")
]

@onready var player = get_node("Sphere")

var maxRotation = 0.3

# Called when the node enters the scene tree for the first time.
func _ready():
	next_level()
	
func next_level():
	currentLevel += 1
	levelNode = levels[currentLevel].instantiate()
	add_child(levelNode)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	process_input(delta)

func _physics_process(delta):
	pass

func process_input(delta):
	var diff = delta * 3
	
	if check_lose():
		# YOU LOSE!
		return
	
	var zAdjusted = false
	if Input.is_action_pressed("ui_left"):
		levelNode.rotation.z = lerp(levelNode.rotation.z, maxRotation, diff)
		zAdjusted = true
	if Input.is_action_pressed("ui_right"):
		levelNode.rotation.z = lerp(levelNode.rotation.z, -maxRotation, diff)
		zAdjusted = true
	
	var xAdjusted = false
	if Input.is_action_pressed("ui_up"):
		levelNode.rotation.x = lerp(levelNode.rotation.x, -maxRotation, diff)
		xAdjusted = true
	if Input.is_action_pressed("ui_down"):
		levelNode.rotation.x = lerp(levelNode.rotation.x, maxRotation, diff)
		xAdjusted = true

	if !zAdjusted:
		levelNode.rotation.z = lerp(levelNode.rotation.z, 0.0, diff)
	if !xAdjusted:
		levelNode.rotation.x = lerp(levelNode.rotation.x, 0.0, diff)

func check_lose():
	var sphereY = player.position.y;
	return sphereY <= -50
