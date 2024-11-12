extends Sprite2D

var player : Player = null
@onready var bubble : Sprite2D = $"Bubble"
@onready var text_system : Node2D = $"Text System"
@onready var game : Node2D = $"/root/Game"

var interacted : bool = false

func _physics_process(delta : float):
	var action : bool = false

	if player != null and game.got_research == false:
		if Input.is_action_just_pressed(&"interact"):
			text_system.set_current("Message")
			action = true

		action = text_system.process(delta, action)
		if action:
			interacted = true
			player.freeze(true)
			bubble.visible = false
		else:
			if interacted:
				game.got_research = true
				texture = load("res://lab-server-deactivated.png")
			player.freeze(false)

func _on_player_sense_body_entered(body : Node2D):
	if body is Player:
		player = body

func _on_player_sense_body_exited(body : Node2D):
	if body is Player:
		player = null
