extends Resource

@export var point_cost: int
@export var strength: int
@export var health: int

func _init(p_health = 0, p_strength = 0, p_cost = 0):
	health = p_health
	strength = p_strength
	point_cost = p_cost
