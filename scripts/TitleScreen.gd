extends ColorRect

@export var FADEOUT_SPEED: float = 5
var started: bool = false


func _ready():
	# Disable input on startup
	get_tree().get_root().set_disable_input(true)

func _physics_process(delta):
	
	# While no first input keep checking
	if !started:
		var input = Input.get_vector("backward", "forward", "down", "up")

		# Hide Title screen when any movement is performed
		if input:
			started = true;
			
		return

	# Here, the game has already started

	var currentColor: Color = get_modulate()

	# If the Title screen is (almost) invisible,
	if currentColor.a <= 0.01:
		# Re-enable input
		get_tree().get_root().set_disable_input(false)
		# hide it
		visible = false;
		# and destroy it
		queue_free()
	else:
		# fade it out
		set_modulate(lerp(currentColor, Color(1,1,1,0), FADEOUT_SPEED * delta))
	
	
	
	
	
	
