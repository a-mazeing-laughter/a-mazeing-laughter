extends Node3D

var levelNode;
var currentLevel = -1
@onready var levels = [
	preload("res://scenes/levels/level-1.tscn")
]

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
	var diff = delta * 0.75
	
	var zAdjusted = false
	if Input.is_action_pressed("ui_left"):
		levelNode.rotation.z += diff
		if levelNode.rotation.z > maxRotation:
			levelNode.rotation.z = maxRotation
		zAdjusted = true
	if Input.is_action_pressed("ui_right"):
		levelNode.rotation.z -= diff
		if levelNode.rotation.z < -maxRotation:
			levelNode.rotation.z = -maxRotation
		zAdjusted = true
	if !zAdjusted:
		if levelNode.rotation.z > 0:
			levelNode.rotation.z -= diff
		if levelNode.rotation.z < 0:
			levelNode.rotation.z += diff
	
	var xAdjusted = false
	if Input.is_action_pressed("ui_up"):
		levelNode.rotation.x -= diff
		if levelNode.rotation.x < -maxRotation:
			levelNode.rotation.x = -maxRotation
		xAdjusted = true
	if Input.is_action_pressed("ui_down"):
		levelNode.rotation.x += diff
		if levelNode.rotation.x > maxRotation:
			levelNode.rotation.x = maxRotation
		xAdjusted = true
	if !xAdjusted:
		if levelNode.rotation.x > 0:
			levelNode.rotation.x -= diff
		if levelNode.rotation.x < 0:
			levelNode.rotation.x += diff
	
	print_debug("x", levelNode.rotation.x, "z", levelNode.rotation.z)
