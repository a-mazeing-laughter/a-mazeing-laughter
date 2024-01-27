extends Node2D


func _ready():
	pass


func _process(_delta):
	if Input.is_action_pressed("ui_accept"):
		_on_start_button_pressed()


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main/credits.tscn")
