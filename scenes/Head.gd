extends Node3D

@export var mouse_sens = .5

@onready var Camera = $"Camera3D"
# Called when the node enters the scene tree for the first time.
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
		Camera.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
		Camera.rotation.x = clamp(Camera.rotation.x, deg_to_rad(-89),deg_to_rad(89))
