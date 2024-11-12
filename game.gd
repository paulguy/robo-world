extends Node2D

@onready var title : Sprite2D = $"Title Overlay"
@onready var title_camera : Camera2D = $"Title Overlay/Camera2D"
@onready var player : CharacterBody2D = $"Player"
@onready var player_camera : Camera2D = $"Player/Player Camera"
@onready var ambience : AudioStreamPlayer2D = $"Ambience"

var got_research : bool = false

func _ready():
	player.freeze(true)

func _physics_process(_delta : float):
	if Input.is_action_just_released(&"start"):
		title.visible = false
		title_camera.enabled = false
		player_camera.enabled = true
		ambience.play()
		player.freeze(false)
