extends Panel
class_name NoiseShader

@onready var player_camera : Camera2D = $"../Player Camera"
@onready var noise_tex : FastNoiseLite = material.get_shader_parameter(&"noise").noise
@onready var animator : AnimationPlayer = $"Noise Fade Animation"

@export var effect_intensity : float = 0.0

func _process(_delta : float):
	position = -(size / 2.0) + player_camera.position
	noise_tex.seed = randi()
	material.set_shader_parameter(&"noise_scale", effect_intensity)

func _on_corruption_area_body_entered(_body: Node2D) -> void:
	animator.play(&"fade in")

func _on_corruption_area_body_exited(_body: Node2D) -> void:
	animator.play(&"fade out")
