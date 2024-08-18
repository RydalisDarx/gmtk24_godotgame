extends Node
class_name SceneLogic

const LEVELPATH = "res://scenes/levels/"

@onready var m_Player : Player = get_node("Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	m_Player.SetProperties(GPlayerProperties)
	m_Player.m_Properties.Print()

# Load a scene from a scenename
func _loadScene(scenename):
	var playerProperties =  m_Player.GetProperties()
	GPlayerProperties.set_upgrades(playerProperties.permanent_upgrades)
	get_tree().change_scene_to_file.call_deferred(LEVELPATH + scenename)
