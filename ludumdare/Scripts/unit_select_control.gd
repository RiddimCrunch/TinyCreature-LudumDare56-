class_name UnitControlModule

extends Control

var brush = []
var isSelecting = false

func recordBrush(p: Vector2):
	brush.append(p)
	queue_redraw()
	
func clearBrush():
	brush.clear()
	queue_redraw()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	queue_redraw()

var dragging = false
var drag_counter = 0
var drag_max = 10
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				recordBrush(event.position)
			elif event.is_released():
				recordBrush(event.position)
				recordBrush(brush[0])
				isSelecting = !isSelecting
	
	if event is InputEventMouseMotion and dragging:
		drag_counter+=1
		if drag_counter > drag_max:
			drag_counter=0
			recordBrush(event.position)
			

func _draw() -> void:
	var color = Color.AQUAMARINE if !isSelecting else Color.BLUE
	var size =  brush.size()
	for i in range(size-1):
		var next_index = i+1
		if next_index < size:
			draw_line(brush[i], brush[next_index], Color.AQUAMARINE, 4)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
