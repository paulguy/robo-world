extends CharacterBody2D
class_name Player

const SPEED : float = 10000.0
const GRAVITY : float = 1000.0
const GRAPPLE_OFFSET : Vector2 = Vector2(0, -21.0)
const DRAW_STRENGTH : float = 2000.0
const DAMPING : float = 0.99

@onready var sprite : AnimatedSprite2D = $"Sprite"
@onready var grapple : CharacterBody2D = $"../Grapple"
@onready var grapple_rope : Polygon2D = $"../Grapple Rope"
@onready var camera : Camera2D = $"Player Camera"
@onready var turning_sound : AudioStreamPlayer = $"Turning Sound"
var facing_right : bool = true
var animating : bool = false
var mousepos : Vector2 = Vector2.ZERO
var draw_vector : Vector2 = Vector2.ZERO
var frozen : bool = false

func _ready():
	sprite.play("move_right")

func _input(event):
	if event is InputEventMouse:
		mousepos = event.position

func _physics_process(delta : float):
	if frozen:
		return

	if Input.is_action_just_pressed(&"grapple"):
		var click_pos : Vector2 = (mousepos - (get_viewport_rect().size / 2.0)) + camera.position - GRAPPLE_OFFSET

		grapple.cancel()
		grapple.fire(position + GRAPPLE_OFFSET, click_pos.angle())
	elif Input.is_action_just_pressed(&"cancel_grapple"):
		grapple.cancel()

	var movement : float = Input.get_axis(&"move_left", &"move_right")

	if not is_on_floor() or draw_vector != Vector2.ZERO:
		velocity.y += GRAVITY * delta
	else:
		velocity = Vector2.ZERO
		if not animating:
			if movement < 0.0 and facing_right:
				# turning left
				animating = true
				facing_right = false
				sprite.play(&"turning")
				turning_sound.play()
			elif movement > 0.0 and not facing_right:
				# turning right
				animating = true
				facing_right = true
				sprite.play_backwards(&"turning")
				turning_sound.play()
			elif movement == 0.0:
				sprite.pause()
			else:
				sprite.play()
				velocity.x = movement * SPEED * delta

	velocity += draw_vector * delta * DRAW_STRENGTH
	velocity *= DAMPING

	move_and_slide()

func draw_in(vec):
	draw_vector = vec

func stop_drawing_in():
	draw_vector = Vector2.ZERO

func freeze(arg : bool):
	grapple.frozen = arg
	frozen = arg

func _on_sprite_animation_finished() -> void:
	animating = false
	if facing_right:
		sprite.play(&"move_right", 0.0)
	else:
		sprite.play(&"move_left", 0.0)
	sprite.pause()
