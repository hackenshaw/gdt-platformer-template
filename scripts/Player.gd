extends CharacterBody3D


@export var SPEED : float = 5
@export var SMOOTH_SPEED: float = 10
@export var ROTATION_SPEED: float = 5
@export var FALL_DECAY: float = 100
const JUMP_VELOCITY = 4.5

@onready var model: Node3D = $Model
@onready var animTree: AnimationTree = find_child("AnimationTree")
@onready var animPlayer: AnimationPlayer = find_child("AnimationPlayer")

var _active: bool = true
var direction: Vector3 = Vector3.ZERO
var lastDirection: Vector3 = Vector3.FORWARD

var _footstepSound: AudioStream = preload("res://resources/audio/sfx/steps_floor.ogg")

var rng = RandomNumberGenerator.new()


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0

	# Handle Jump.
	if _active and Input.is_action_just_pressed("up") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
		pass

	if _active:
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir = Input.get_vector("backward", "forward", "down", "up")
		direction = (transform.basis * Vector3(0, 0, -input_dir.x)).normalized()
		
	
	if is_on_floor(): # don't walk while airborn
		velocity.x = lerp(velocity.x, direction.x * SPEED, SMOOTH_SPEED * delta)
		velocity.z = lerp(velocity.z, direction.z * SPEED, SMOOTH_SPEED * delta)

		# set animation blend based on speed
		animTree.set("parameters/IdleToRun/blend_position", velocity.length() / SPEED)
	else:
		velocity.x = lerp(velocity.x, 0.0, SMOOTH_SPEED * delta / FALL_DECAY)
		velocity.z = lerp(velocity.z, 0.0, SMOOTH_SPEED * delta / FALL_DECAY)
		# TODO: falling???
		animTree.set("parameters/IdleToRun/blend_position", 0)


	move_and_slide()

	# save last move direction
	if direction:
		lastDirection = direction
	
	# rotate player to face movement direction
	model.rotation.y = lerp_angle(model.rotation.y, atan2(lastDirection.x, lastDirection.z), ROTATION_SPEED * delta)


func _on_console_activated():
	_active = false


func _on_console_deactivated():
	_active = true


func _on_area_3d_body_entered(_body: Node3D) -> void:
	var random_pitch = rng.randf_range(0.5, 1.5)
	var asPlayer = SoundManager.play_sound(_footstepSound, "SFX")
	asPlayer.pitch_scale = random_pitch
