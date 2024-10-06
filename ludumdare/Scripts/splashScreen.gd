class_name SplashScreen extends Control

@export var time = 3
@export var fadeTime = 1


signal finished()

func start():
	modulate.a = 0
	show()
	var tween: Tween = create_tween()
	tween.connect("finished", finish)
	tween.tween_property(self, "modulate:a", 1, fadeTime)
	tween.tween_interval(time)
	tween.tween_property(self, "modulate:a", 0, fadeTime)
	
func finish():
	emit_signal("finished")
	queue_free()
