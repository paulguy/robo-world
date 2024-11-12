extends Node2D

func _ready():
	var sprites : Array = [load("res://robot-1.png"),
						  load("res://robot-2.png"),
						  load("res://robot-3.png")]

	var option
	for column in get_children():
		for child in column.get_children():
			option = randi_range(0, 3)
			if option == 0:
				column.remove_child(child)
			else:
				child.texture = sprites[option-1]
