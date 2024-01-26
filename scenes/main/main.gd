extends Node3D

var levelNode;
var currentLevel = -1
@onready var levels = [
	preload("res://scenes/levels/level-1.tscn")
]

# Called when the node enters the scene tree for the first time.
func _ready():
	next_level()
	
func next_level():
	currentLevel += 1
	levelNode = levels[currentLevel].instantiate()
	add_child(levelNode)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _physics_process(delta):
	var diff = delta * 2
	
	if Input.is_action_just_pressed("ui_left"):
		levelNode.rotation.z += diff
	
	if Input.is_action_just_pressed("ui_right"):
		levelNode.rotation.z -= diff
		
	if Input.is_action_just_pressed("ui_up"):
		levelNode.rotation.x -= diff
	
	if Input.is_action_just_pressed("ui_down"):
		levelNode.rotation.x += diff
