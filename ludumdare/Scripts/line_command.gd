extends Line2D

class_name LineCommand

signal command_done(points: PackedVector2Array)

@export var line_length = 30
	
var dragging = false
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			add_point(event.position)
			dragging = true
		elif dragging and not event.pressed:
			dragging = false
			command_done.emit(points)
			clear_points()

func _physics_process(delta: float) -> void:
	if dragging and get_point_count() <= line_length:
		var p = get_global_mouse_position()
		var length = (p - get_point_position(get_point_count()-1)).length()
		if length > 50:
			add_point(p)
