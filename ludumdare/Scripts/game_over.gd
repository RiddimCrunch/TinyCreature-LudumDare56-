extends Control

func _on_game_over() -> void:
	visible = true

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()

func _on_main_screen_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menu/MainMenu.tscn")
