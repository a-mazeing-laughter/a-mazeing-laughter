extends Node3D

@onready var ground = get_node("Ground")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _physics_process(delta):
	var diff = delta * 2
	
	if Input.is_action_just_pressed("ui_left"):
		ground.rotation.z += diff
	
	if Input.is_action_just_pressed("ui_right"):
		ground.rotation.z -= diff
		
	if Input.is_action_just_pressed("ui_up"):
		ground.rotation.x -= diff
	
	if Input.is_action_just_pressed("ui_down"):
		ground.rotation.x += diff
	
