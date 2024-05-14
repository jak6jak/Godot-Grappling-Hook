extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SWING_SPEED = 5
const MAX_FALLING_WALK_SPEED =6
@onready var Head = $"Head"
@onready var camera = $"Head/Camera3D"
@onready var prev_pos = transform.origin
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var grappling: bool = false
var grapple_anchor: Vector3
@onready var GroundCheckRay = $GroundCheckRay


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):

	if event.is_action_released("grapple"):
		grappling = false
		

func verletIntegration(prev_pos: Vector3, forces: Vector3, delta: float):
	var accel = forces # 1.0 is the mass of the player
	var new_pos =  2 * transform.origin - prev_pos + accel * pow(delta,2)
	return new_pos
	

func constrain_rope(pos : Vector3, max_rope_length: float):
	var rope_vector = pos - grapple_anchor
	if rope_vector.length()> max_rope_length:
		rope_vector = rope_vector.normalized() * max_rope_length
		return grapple_anchor + rope_vector
	return pos


func _physics_process(delta):

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (Head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	#Test if grapple shot hits
	if Input.is_action_just_pressed("grapple") and not grappling:
		#Check if grapple shot hit an object
		var viewPortSize = get_viewport().size
		var space_state = get_world_3d().direct_space_state
		var from = camera.project_ray_origin(Vector2(viewPortSize.x/2,viewPortSize.y/2))
		var to = from + camera.project_ray_normal(Vector2(viewPortSize.x/2,viewPortSize.y/2)) * 100
		var query = PhysicsRayQueryParameters3D.create(from,to,1)
		var RayCast= space_state.intersect_ray(query)
		
		if RayCast.size() > 0:
			grappling = true
			grapple_anchor = RayCast.position

	#move player as grappling
	if grappling or not is_on_floor():
		var alignment = direction.dot(Vector3(velocity.x,0,velocity.z).normalized())
		var speed_modifier = max(.5,alignment) * 1.1
		var total_forces = direction * SWING_SPEED
		if not GroundCheckRay.is_colliding():
			total_forces += Vector3(0,-gravity,0)
		var new_pos = verletIntegration(prev_pos,total_forces,delta)
		if grappling:
			var rope_length = transform.origin.distance_to(grapple_anchor)
			new_pos = constrain_rope(new_pos, rope_length)
		var nextVelocity = new_pos - transform.origin
		
		velocity = (new_pos - transform.origin) / delta
		
		prev_pos = transform.origin
		move_and_slide()
	else:
		if not is_on_floor():
			"""
			var alignment = direction.dot(Vector3(velocity.x,0,velocity.z).normalized())
			var speed_modifier = max(.5,alignment) * 1.1
			var total_forces = direction * SWING_SPEED * speed_modifier
			if not GroundCheckRay.is_colliding():
				total_forces += Vector3(0,-gravity,0)
			var new_pos = verletIntegration(prev_pos,total_forces,delta)
			
			var nextVelocity = new_pos - transform.origin
		
			velocity = (new_pos - transform.origin) / delta
			
			prev_pos = transform.origin
			move_and_slide()
			"""
		
			velocity.y -= gravity * delta

			velocity.x += direction.x * SPEED
			velocity.z += direction.z * SPEED
			# Store the current position
			prev_pos = transform.origin

			#Move the character and handle collisions
			move_and_slide()

		else:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			prev_pos = transform.origin
			move_and_slide()
