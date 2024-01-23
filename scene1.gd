extends Node2D

@export var level = PackedScene


func _on_player_tree_exited():
	get_tree().reload_current_scene()
