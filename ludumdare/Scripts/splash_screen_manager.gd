extends Control


@export var moveTo : PackedScene

var splashScreens : Array[SplashScreen] = []

@onready var splashScreenContainer : CenterContainer = $SplashScreenContainer

func _ready() -> void:
	assert(moveTo)
	
	for splashSreen in splashScreenContainer.get_children():
		splashSreen.hide()
		splashScreens.push_back(splashSreen)
		
	startSplashScreen()
	
func startSplashScreen():
	if splashScreens.size() == 0:
		get_tree().change_scene_to_packed(moveTo)
	else:
		var splashScreen: SplashScreen = splashScreens.pop_front()
		splashScreen.start()
		splashScreen.connect("finished", startSplashScreen)
