extends Control


func _on_resume_pressed() -> void:
	visible = false
	get_tree().paused = false

func _on_main_screen_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Menu/MainMenu.tscn")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Escape"):
		toggle_pause_menu()


func toggle_pause_menu() -> void:
	if visible:
		visible = false
		get_tree().paused = false
	else:
		visible = true
		get_tree().paused = true

func isVisible() -> bool:
	return visible
