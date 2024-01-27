extends Node2D


func _ready():
	get_tree().get_root().size_changed.connect(screenSizeChanged) 
	centerText()
	process_mode = Node.PROCESS_MODE_ALWAYS


func _process(_delta):
	if Input.is_action_pressed("ui_r_key"):
		self.queue_free()
		get_tree().reload_current_scene()
		get_tree().paused = false


func centerText():
	var loosingText = get_node("LoosingText")
	loosingText.position = get_viewport_rect().size/2
	loosingText.position.x = loosingText.position.x - loosingText.get_content_width()/2
	loosingText.position.y = loosingText.position.y - loosingText.get_content_height()/2


func screenSizeChanged():
	centerText()
