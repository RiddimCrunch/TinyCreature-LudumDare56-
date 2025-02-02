extends Node2D

class_name BoxSelect

signal selection_done(box_start: Vector2, box_end: Vector2)
	
var start: Vector2 = Vector2(0,0)
var end: Vector2 = Vector2(0,0)
var dragging = false
var color: Color = Color.AQUAMARINE
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			start = event.position
			dragging = true
		elif dragging and not event.pressed:
			selection_done.emit(start, end)
			start = Vector2(0,0)
			end = Vector2(0,0)
			queue_redraw()
			dragging = false
			
func _draw() -> void:
	var width = 5
	draw_dashed_line(start, Vector2(start.x, end.y), color, width)
	draw_dashed_line(start, Vector2(end.x, start.y), color, width)
	draw_dashed_line(Vector2(start.x, end.y), end, color, width)
	draw_dashed_line(Vector2(end.x, start.y), end, color, width)
		
func _physics_process(_delta: float) -> void:
	if dragging:
		end = get_global_mouse_position()
		queue_redraw()
