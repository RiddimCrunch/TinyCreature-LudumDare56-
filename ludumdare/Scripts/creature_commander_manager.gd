extends Node2D

class_name CreatureCommander

@onready var root = $".."
@onready var box_select = $BoxSelect
@onready var line_command = $LineCommand
var selected_obj: Array[Ally] = []
var outline_mat = preload("res://Assets/Ally/outline_mat.tres")
var blink = preload("res://Assets/Ally/Ally.tres")

enum ColorFilter { red, green, blue, none }
var active_color_filter = ColorFilter.none

var pointers = {
	ColorFilter.red: preload("res://Assets/Cursor/pointer_red.png"),
	ColorFilter.green: preload("res://Assets/Cursor/pointer_green.png"),
	ColorFilter.blue: preload("res://Assets/Cursor/pointer_blue.png"),
	ColorFilter.none: preload("res://Assets/Cursor/pointer.png"),
}

var flags = {
	ColorFilter.red: preload("res://Assets/Cursor/flag_red.png"),
	ColorFilter.green: preload("res://Assets/Cursor/flag_green.png"),
	ColorFilter.blue: preload("res://Assets/Cursor/flag_blue.png"),
	ColorFilter.none: preload("res://Assets/Cursor/flag.png"),
}

var outline_colors = {
	ColorFilter.red: Color.DEEP_PINK,
	ColorFilter.green: Color.GREEN_YELLOW,
	ColorFilter.blue: Color.ROYAL_BLUE,
	ColorFilter.none: Color.AQUAMARINE,
}

func command_mode(enable: bool):
	if enable:
		Input.set_custom_mouse_cursor(flags[active_color_filter])
		box_select.process_mode = Node.PROCESS_MODE_DISABLED
		line_command.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		Input.set_custom_mouse_cursor(pointers[active_color_filter])
		box_select.process_mode = Node.PROCESS_MODE_INHERIT
		line_command.process_mode = Node.PROCESS_MODE_DISABLED
		
func clear_selected():
	for s in selected_obj:
		if s != null:
			var local_blink = blink.duplicate()
			local_blink.set_shader_parameter("flash_modifer", 0)
			s.sprite.material = local_blink
	selected_obj.clear()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	command_mode(false)
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_MASK_RIGHT:
		clear_selected()
		command_mode(false)
	if event.is_action_pressed("Blue"):
		set_active_color_filter(ColorFilter.blue)
	elif event.is_action_pressed("Green"):
		set_active_color_filter(ColorFilter.green)
	elif event.is_action_pressed("Red"):
		set_active_color_filter(ColorFilter.red)
		
func set_active_color_filter(color: ColorFilter):
	if active_color_filter == color:
		active_color_filter = ColorFilter.none
	else:
		active_color_filter = color
		
	clear_selected()
	command_mode(false)
	box_select.color = outline_colors[active_color_filter]
	print(ColorFilter.keys()[active_color_filter])
		
func is_valid_color(type: EntityType.TypeEnum) -> bool:
	if (active_color_filter == ColorFilter.none):
		return true
	if (active_color_filter == ColorFilter.red and type == EntityType.TypeEnum.red):
		return true
	if (active_color_filter == ColorFilter.blue and type == EntityType.TypeEnum.blue):
		return true
	if (active_color_filter == ColorFilter.green and type == EntityType.TypeEnum.green):
		return true
	return false
	

func _on_box_select_selection_done(box_start: Vector2, box_end: Vector2) -> void:
	for a in root.allies:
		var p = a.global_position
		var top_x = box_start.x if box_start.x < box_end.x else box_end.x
		var bot_x = box_start.x if box_start.x > box_end.x else box_end.x
		var top_y = box_start.y if box_start.y < box_end.y else box_end.y
		var bot_y = box_start.y if box_start.y > box_end.y else box_end.y
		if p.x > top_x and p.y > top_y and p.x < bot_x and p.y < bot_y:
			if is_valid_color(a.type.type):
				selected_obj.append(a)
	
	if selected_obj.size() > 0:
		for s in selected_obj:
			s.sprite.material = outline_mat
		command_mode(true)

func _on_line_command_command_done(points: PackedVector2Array) -> void:
	var screen_size = get_viewport().get_visible_rect().size
	var every_p = int(points.size() / selected_obj.size())
	var c = 0
	var p_i = 0
	var obj_i = 0
	while obj_i < selected_obj.size():
		if c > every_p:
			if selected_obj[obj_i] != null:
				selected_obj[obj_i].cmd_set_target(points[p_i].clamp(Vector2.ZERO, screen_size), Ally.AllyState.moving_and_looking)
			c = 0
			obj_i += 1
			
		c += 1
		p_i += 1
		
		if p_i >= points.size():
			p_i = 0
	clear_selected()
	command_mode(false)


func _on_button_red_pressed() -> void:
	set_active_color_filter(ColorFilter.red)


func _on_button_green_pressed() -> void:
	set_active_color_filter(ColorFilter.green)


func _on_button_blue_pressed() -> void:
	set_active_color_filter(ColorFilter.blue)
