extends Polygon2D

@onready var player : CharacterBody2D = $"../Player"
@onready var grapple : CharacterBody2D = $"../Grapple"

func _process(_delta : float):
	if grapple.active:
		visible = true
		position = player.position + player.GRAPPLE_OFFSET
		rotation = (grapple.position - position).angle()
		var distance = (grapple.position - position).length()
		polygon[1].x = distance
		polygon[2].x = distance
	else:
		visible = false
