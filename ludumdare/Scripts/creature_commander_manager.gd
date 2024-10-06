extends Node2D

class_name CreatureCommander

@onready var root = $".."
@onready var box_select = $BoxSelect
@onready var line_command = $LineCommand
var selected_obj: Array[Ally] = []
var outline_mat = preload("res://Assets/Ally/outline_mat.tres")

func command_mode(enable: bool):
	if enable:
		Input.set_custom_mouse_cursor(preload("res://Assets/Cursor/Flag.png"))
		box_select.process_mode = Node.PROCESS_MODE_DISABLED
		line_command.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		Input.set_custom_mouse_cursor(preload("res://Assets/Cursor/Lasso.png"))
		box_select.process_mode = Node.PROCESS_MODE_INHERIT
		line_command.process_mode = Node.PROCESS_MODE_DISABLED
		
func clear_selected():
	for s in selected_obj:
		s.sprite.material = null
	selected_obj.clear()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	command_mode(false)
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_MASK_RIGHT:
		clear_selected()
		command_mode(false)

func _on_box_select_selection_done(box_start: Vector2, box_end: Vector2) -> void:
	for a in root.allies:
		var p = a.global_position
		var top_x = box_start.x if box_start.x < box_end.x else box_end.x
		var bot_x = box_start.x if box_start.x > box_end.x else box_end.x
		var top_y = box_start.y if box_start.y < box_end.y else box_end.y
		var bot_y = box_start.y if box_start.y > box_end.y else box_end.y
		if p.x > top_x and p.y > top_y and p.x < bot_x and p.y < bot_y:
			selected_obj.append(a)
	
	if selected_obj.size() > 0:
		for s in selected_obj:
			s.sprite.material = outline_mat
		command_mode(true)

func _on_line_command_command_done(points: PackedVector2Array) -> void:
	var screen_size = get_viewport().get_visible_rect().size
	var every_p = int(points.size() / selected_obj.size())
	print(points.size())
	print(selected_obj.size())
	var c = 0
	var p_i = 0
	var obj_i = 0
	while obj_i < selected_obj.size():
		if c > every_p:
			selected_obj[obj_i].cmd_set_target(points[p_i].clamp(Vector2.ZERO, screen_size), Ally.AllyState.moving_and_looking)
			c = 0
			obj_i += 1
			
		c += 1
		p_i += 1
		
		if p_i >= points.size():
			p_i = 0
	clear_selected()
	command_mode(false)
