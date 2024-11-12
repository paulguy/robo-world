extends Sprite2D

var player : Player = null
@onready var bubble : Sprite2D = $"Bubble"
@onready var text_system : Node2D = $"Text System"
@onready var game : Node2D = $"/root/Game"
@onready var sounds : Array = [$"Sound 1", $"Sound 2"]
var game_ended : bool = false

var interacted : bool = false
var one_frame : bool = true

func _physics_process(delta : float):
	var action : bool = false

	if player != null:
		if Input.is_action_just_pressed(&"interact"):
			var message : String = "Messages 1"
			if game_ended:
				message = "Messages 3"
			elif game.got_research:
				message = "Messages 2"

			text_system.set_current(message)
			action = true

		action = text_system.process(delta, action)
		if action:
			interacted = true
			if one_frame:
				sounds[randi_range(0, len(sounds)-1)].play()
			one_frame = false
			player.freeze(true)
			bubble.visible = false
		else:
			if interacted:
				if not one_frame:
					one_frame = true
				else:
					if game.got_research:
						game_ended = true
					interacted = false
					player.freeze(false)
					bubble.visible = true

func _on_player_sense_body_entered(body : Node2D):
	if body is Player:
		player = body

func _on_player_sense_body_exited(body : Node2D):
	if body is Player:
		player = null
