extends Node2D


func _ready():
	pass


func _process(_delta):
	pass



func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")
	#var mainScene = preload("res://scenes/main/main.tscn").instantiate()
	#get_tree().root.add_child(mainScene)


func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main/credits.tscn")
