extends Node

var musicProgress := 0
var currentScene := ""

func playMusic(stream, volume):
	TrueMusicPlayer.stream = stream
	TrueMusicPlayer.volume_db = volume
	TrueMusicPlayer.play()
	
func stopMusic():
	TrueMusicPlayer.stop()
	
	

func _getCurrentScene():
	return currentScene
	
func _setCurrentScene(scene_name: String):
	currentScene = scene_name
