extends Node2D

func _on_player_tree_exited():
	if (get_tree() != null):
		get_tree().reload_current_scene() 
