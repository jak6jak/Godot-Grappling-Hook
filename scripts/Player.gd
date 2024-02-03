extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var Head = $"Head"
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var grappling = false

func _input(event):

	if event.is_action_released("grapple"):
		grappling = false
		

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

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
		if true:
			grappling = true
			pass
		else:
			pass

		
	
	#move player as grappling
	if grappling:
		pass
	else:
		if not is_on_floor():
			pass
		else:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED

	move_and_slide()
