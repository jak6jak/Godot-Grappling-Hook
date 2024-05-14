extends MeshInstance3D

var anchor_pos: Vector3
func StartedGrappling(anchor: Vector3):
	anchor_pos = anchor
	visible = true
	var tween = get_tree().create_tween()
	tween.parallel().tween_method(set_uniform_maxAmplitude, 1,.5,.3)
	tween.parallel().tween_method(set_uniform_frequency, 5,0.1,.3)
	tween.parallel().tween_property(self, "scale",Vector3(scale.x,scale.y,global_transform.origin.distance_to(anchor_pos)),.33)

func set_uniform_maxAmplitude(value:float):
	get_surface_override_material(0).set_shader_parameter("maxAmplitude", value)

func set_uniform_frequency(value: float):
	get_surface_override_material(0).set_shader_parameter("frequency", value)

func UnGrapple():
	visible = false
	scale.z = 1

func _ready():
	anchor_pos = Vector3(0,1,0)
	visible = false

func _process(delta):
	var ropeLength = global_transform.origin.distance_to(anchor_pos)
	look_at(anchor_pos)
