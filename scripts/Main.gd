extends Node3D

@onready var isFullscreen: bool = DisplayServer.window_get_mode()


func fullscreenToggle() -> void:
	isFullscreen = !isFullscreen
	if isFullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _ready():
	
	# Capture the mouse (make it invisible)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Add command to toggle fullscreen
	Console.create_command("fullscreenToggle", self.fullscreenToggle, "toggle the window fullscreen mode.")

