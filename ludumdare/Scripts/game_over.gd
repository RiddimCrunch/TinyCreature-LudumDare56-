extends Control

func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/World.tscn")

func _on_main_screen_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menu/MainMenu.tscn")

@onready var blue = $Tile0109Blue
@onready var green = $Tile0109Green
@onready var red = $Tile0109Red
@onready var orange = $Tile0109

var time_passed = 0.0
var amplitude = 0.2  # La distance maximum du mouvement (en pixels)
var frequency = 10   # La vitesse du mouvement

func move(delta):
	time_passed += delta
	var sine_wave = sin(time_passed * frequency) * amplitude
	blue.position.y += sine_wave
	green.position.y += sine_wave
	red.position.y += sine_wave
	orange.position.y += sine_wave
	blue.position.x += sine_wave
	green.position.x += sine_wave
	red.position.x += sine_wave
	orange.position.x += sine_wave

func _process(delta: float) -> void:
	move(delta)
