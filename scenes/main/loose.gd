extends Node2D


func _ready():
	get_tree().get_root().size_changed.connect(screenSizeChanged) 
	centerText()


func _process(_delta):
	pass


func centerText():
	var loosingText = get_node("LoosingText")
	loosingText.position = get_viewport_rect().size/2


func screenSizeChanged():
	centerText()
