extends Resource

const Mob = preload("res://Scripts/mob.gd")
enum MobTypesEnum { normal_mob, big_mob }

var mob_types = {
	MobTypesEnum.normal_mob: Mob.new(100, 10, 10),
	MobTypesEnum.big_mob: Mob.new(1000, 50, 100) 
}

func _init():
	pass
