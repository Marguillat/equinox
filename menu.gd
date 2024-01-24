extends Control

func _ready():
	pass # Replace with function body.

func _on_play_but_pressed():
	get_tree().change_scene_to_file("res://scene1.tscn")

func _on_credit_but_pressed():
	get_tree().change_scene_to_file("res://scene1.tscn")
