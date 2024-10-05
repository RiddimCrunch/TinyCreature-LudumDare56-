extends Control


func _on_resume_pressed() -> void:
	visible = false


func _on_options_pressed() -> void:
	pass # Replace with function body.


func _on_main_screen_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menu/MainMenu.tscn")
