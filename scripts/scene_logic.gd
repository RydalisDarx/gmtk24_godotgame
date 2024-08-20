extends Node
class_name SceneLogic

const LEVELPATH = "res://scenes/levels/"

@onready var m_Player : Player = get_tree().get_first_node_in_group("Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	m_Player.SetProperties(GPlayerProperties)
	m_Player.m_Properties.Print()
	
	print(self.name)
	print(SceneManager.currentScene)
	if SceneManager.currentScene != get_tree().current_scene.scene_file_path:
		if has_node("MusicPlayer"):
			var mp = $MusicPlayer
			SceneManager.playMusic(mp.stream, mp.volume_db)
		SceneManager.currentScene = get_tree().current_scene.scene_file_path

# Load a scene from a scenename
func _loadScene(scenename):
	var playerProperties =  m_Player.GetProperties()
	GPlayerProperties.set_upgrades(playerProperties.permanent_upgrades)
	get_tree().change_scene_to_file.call_deferred(LEVELPATH + scenename)

func _reload():
	print("reloading")	
	get_tree().reload_current_scene()
	
