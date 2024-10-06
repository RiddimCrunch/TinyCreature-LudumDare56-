extends Control

func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed(preload("res://Scenes/World.tscn"))

func _on_quit_pressed() -> void:
	get_tree().quit()
