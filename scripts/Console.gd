extends ColorRect

signal activated
signal deactivated

#@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var consoleInput = find_child("ConsoleContainer")._console_input


func _unhandled_input( event: InputEvent ) -> void:
	if ( event.is_action_released("ui_console") ):
		toggleShow()

func _ready():
	set_visible(false)
	Console.create_command("exit", self.toggleShow, "close the console.")

func _process(_delta):
	# Get the focus back if we lost it
	if (visible and (!consoleInput.has_focus() or Input.mouse_mode == Input.MOUSE_MODE_CAPTURED)):
		activate()

func toggleShow() -> void:
	set_visible(!visible)
	if visible:
		activate()
	else:
		deactivate()

func deactivate():
	# hide the mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	emit_signal("deactivated")
	
func activate():
	# get the mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# get focus so we can start typing immediately
	consoleInput.grab_focus()
	emit_signal("activated")
	

