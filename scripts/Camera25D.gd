extends Camera3D

@export var target: Node3D = null
@export var offset: Vector3
@export var smoothSpeed: float = 2

@export var noiseSpeed: float = 5.0
@export var noiseStrength: float = 1.0
#@export var noiseDecay: float = 3.0

@onready var noise: FastNoiseLite = FastNoiseLite.new()
@onready var rand: RandomNumberGenerator = RandomNumberGenerator.new()
@onready var noiseOffset: Vector3
var noise_i: float = 0.0

var cameraTarget: Node3D

func _ready():
	# find camera target within target node
	cameraTarget = target.find_child("CameraTarget")
	# When games starts, snap camera to desired location
	self.position = cameraTarget.global_position + offset

	# Randomize generated noise
	rand.randomize()
	noise.seed = rand.randi()

func _physics_process(delta) -> void:
	noiseOffset = getNoiseOffset(delta)

	# Smoothly move the camera to the offset away from the target
	# (and add noise offset)
	# lerp only in z (use only the z value of the cameraTarget position)
	self.position = lerp(self.position,
		Vector3(0, 0, cameraTarget.global_position.z) + offset + noiseOffset,
		smoothSpeed * delta)

# Function to get noise offset from generated noise
func getNoiseOffset(delta: float) -> Vector3:
	noise_i += delta * noiseSpeed

	# Set the x value of each call to get_noise_2d to a different value
	# so x and y will be reading from unrelated areas of noise
	# Return vector with y and z offsets since we only move Up/Down/Left/Right
	return Vector3(
		0,
		noise.get_noise_2d(1, noise_i) * noiseStrength,
		noise.get_noise_2d(100, noise_i) * noiseStrength)
