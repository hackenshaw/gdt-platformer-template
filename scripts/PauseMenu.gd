extends ColorRect

#@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var resumeButton: Button = find_child("ResumeButton")
@onready var quitButton: Button = find_child("QuitButton")

var paused: bool = false;

func _unhandled_input( event: InputEvent ) -> void:
	if ( event.is_action_pressed("ui_cancel") ):
		togglePause()

func _ready() -> void:
	set_visible(paused)
	resumeButton.pressed.connect(togglePause)
	quitButton.pressed.connect(get_tree().quit)

func togglePause() -> void:
	paused = !paused
	if paused:
		pause()
	else:
		unpause()
	
func unpause():
	# todo: call animator.play("Unpause")
	set_visible(false)
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func pause():
	# todo: call animator.play("Pause")
	set_visible(true)
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

