extends CharacterBody2D
class_name Grapple

const GRAVITY : float = 1000.0
const FIRE_STRENGTH : float = 600.0
const GRAPPLE_MASK : int = 0x4 # layer 3
const MAX_GRAPPLE_LENGTH : float = 1000.0

@onready var player : CharacterBody2D = $"../Player"
@onready var sound : AudioStreamPlayer2D = $"Sound"
@onready var hit_sound : AudioStreamPlayer2D = $"Hit Sound"

var active : bool = false
var grappled : bool = false
var frozen : bool = false

func fire(pos, angle):
	position = pos
	velocity = Vector2.RIGHT.rotated(angle) * FIRE_STRENGTH
	active = true
	visible = true
	grappled = false
	sound.play()

func cancel():
	active = false
	visible = false
	grappled = false
	velocity = Vector2.ZERO
	player.stop_drawing_in()
	sound.stop()

func _physics_process(delta : float):
	if frozen:
		return

	var draw_vector : Vector2 = position - player.position - player.GRAPPLE_OFFSET

	if active and not grappled:
		if draw_vector.length() > MAX_GRAPPLE_LENGTH:
			cancel()
		else:
			velocity.y += delta * GRAVITY

			move_and_slide()
			var collisions = get_slide_collision_count()
			if collisions > 0:
				for i in collisions:
					var collision : KinematicCollision2D = get_slide_collision(i)
					var collider : Node2D = collision.get_collider()
					var mask : int = 0
					if collider is TileMapLayer:
						for j in collider.tile_set.get_physics_layers_count():
							mask |= collider.tile_set.get_physics_layer_collision_layer(j)
					else:
						mask = collider.collision_layer
					if mask & GRAPPLE_MASK:
						hit_sound.play()
						grappled = true
						break
				velocity = Vector2.ZERO
				sound.stop()

	if grappled:
		player.draw_in(draw_vector.normalized())
