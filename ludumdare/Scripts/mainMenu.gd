extends Control

func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed(preload("res://Scenes/World.tscn"))

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_how_to_play_pressed() -> void:
	get_tree().change_scene_to_packed(preload("res://Scenes/Menu/HowToPlayMenu.tscn"))

@onready var phantoms = $Phantoms

var amplitudes = []
var frenquencies = []

var time_passed = 0.0
var amplitude = 0.2  # La distance maximum du mouvement (en pixels)
var frequency = 10   # La vitesse du mouvement

func move(delta):
	time_passed += delta
	for i in range(phantoms.get_child_count()):
		var node = phantoms.get_child(i)
		var sine_wave = sin(time_passed * frenquencies[i]) * amplitudes[i]
		node.position.y += sine_wave

func _ready():
	for i in range(30):
		frenquencies.append(randf_range(5, 10))
		amplitudes.append(randf_range(0, 1))

func _process(delta: float) -> void:
	move(delta)
