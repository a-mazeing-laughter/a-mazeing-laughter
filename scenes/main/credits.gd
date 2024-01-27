extends Node2D


func _ready():
	var creditsText = load_file("res://CREDITS.md")
	get_node("CreditsText").text = creditsText


func _process(_delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/main/start.tscn")


func load_file(filePath):
	var file = FileAccess.open(filePath, FileAccess.READ)
	var credits = file.get_as_text()
	return credits


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main/start.tscn")
