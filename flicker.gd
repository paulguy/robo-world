extends Polygon2D

const MIN_ON_TIME : float = 0.02
const MAX_ON_TIME : float = 0.15
const MIN_OFF_TIME : float = 0.5
const MAX_OFF_TIME : float = 1.0

var next : float = 0.0

func set_next():
	if visible:
		visible = false
		next = randf_range(MIN_OFF_TIME, MAX_OFF_TIME)
	else:
		visible = true
		next = randf_range(MIN_ON_TIME, MAX_ON_TIME)

func _ready():
	set_next()

func _process(delta : float):
	next -= delta
	if next <= 0.0:
		set_next()
