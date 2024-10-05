extends Line2D

@export_category('Trail')
@export var length : = 10

func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	var point = get_global_mouse_position()
	add_point(point, 0)
	
	if get_point_count() > length:
		remove_point(get_point_count() - 1)
