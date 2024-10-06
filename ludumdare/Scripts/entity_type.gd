extends Node

class_name EntityType

@export var type_sprite = {
	TypeEnum.red: preload("res://Assets/Ally/tile_0108.png"), 
	TypeEnum.green: preload("res://Assets/Ally/tile_0108.png"), 
	TypeEnum.blue: preload("res://Assets/Ally/tile_0108.png")
}
enum TypeEnum { red, green, blue } 
var type: TypeEnum

@onready var sprite = $"../Sprite2D"

func _ready() -> void:
	change_type(TypeEnum.red)

func change_type(t: TypeEnum):
	type = t
	sprite.texture = type_sprite[t]
