extends Node2D

const TILEMAP_WIDTH : int = 16
const TILEMAP_HEIGHT : int = 8
const TILEMAP_NULL : int = 32 # space
const ANIMATION_TIME : float = 1.0

var message_groups : Dictionary = {}
var current : String = ""
var shown : int = -1
var remaining : int = 0
var time_passed : float = 0.0

func randomize_box(tml : TileMapLayer):
	var rect : Rect2i = tml.get_used_rect()
	for y in rect.size.y:
		for x in rect.size.x:
			tml.set_cell(Vector2i(x, y) + rect.position, 0, Vector2i(randi_range(0, TILEMAP_WIDTH-1), 0), 0)

func copy_to_box(tml : TileMapLayer, rect : Rect2i, data : Array, start : int, num : int):
	var cells : int = rect.size.x * rect.size.y

	if start >= cells:
		return 0
	elif start + num > cells:
		num -= (start + num) - cells

	var coords : Vector2i = Vector2i.ZERO
	var tm_coords : Vector2i = Vector2i.ZERO
	var val : int
	for i in num:
		coords.x = (start + i) % rect.size.x
		coords.y = (start + i) / rect.size.x
		coords += rect.position
		val = data[start + i]
		if val == TILEMAP_NULL:
			tm_coords.x = -1
			tm_coords.y = -1
		else:
			tm_coords.x = val % TILEMAP_WIDTH
			tm_coords.y = val / TILEMAP_WIDTH
		tml.set_cell(coords, 0, tm_coords, 0)

	return num

func gather_messages(message_group : Node2D):
	var boxes : Array = []
	var boxdata : Array = []

	for child in message_group.get_children():
		if child is TileMapLayer:
			boxes.append(child)
			var textbox : TileMapLayer = child.get_child(0)
			var rect : Rect2i = textbox.get_used_rect()
			# create space to store original data
			boxdata.append(PackedByteArray())
			boxdata[-1].resize(rect.size.x * rect.size.y)
			boxdata[-1].fill(TILEMAP_NULL)
			# gather the data from the tileset
			var coords : Vector2i
			for cell in textbox.get_used_cells():
				coords = textbox.get_cell_atlas_coords(cell)
				cell -= rect.position
				boxdata[-1][(rect.size.x * cell.y) + cell.x] = (coords.y * TILEMAP_WIDTH) + coords.x
			randomize_box(textbox)

	return [boxes, boxdata]

func _ready():
	for child in get_children():
		message_groups[child.name] = gather_messages(child)

func process(delta : float, action : bool):
	var active : bool = false

	if current != "":
		active = true
		var item : Array = message_groups[current]
		var boxes : Array = item[0]
		var boxdata : Array = item[1]

		if remaining == 0:
			time_passed = 0.0
			if action:
				active = false
				# return false for 1 frame to indicate a next message
				if shown >= 0:
					boxes[shown].visible = false
					randomize_box(boxes[shown].get_child(0))
				shown += 1
				if shown < len(boxes):
					boxes[shown].visible = true
					var rect : Rect2i = boxes[shown].get_child(0).get_used_rect()
					remaining = rect.size.x * rect.size.y
				else:
					shown = -1
					current = ""
		else:
			var textbox : TileMapLayer = boxes[shown].get_child(0)
			var rect : Rect2i = textbox.get_used_rect()
			var cells : int = rect.size.x * rect.size.y
			var start : int = cells - remaining
			time_passed += delta
			remaining -= copy_to_box(textbox,
									rect,
									boxdata[shown],
									start,
									(cells * (time_passed / ANIMATION_TIME)) - start)

	return active

func set_current(arg : String):
	current = arg
