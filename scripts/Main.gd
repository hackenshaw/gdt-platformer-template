extends Node3D

@onready var isFullscreen: bool = DisplayServer.window_get_mode()

var _ambSound : AudioStream = preload("res://resources/audio/music/wind-outside-sound-ambient-141989.mp3")

func fullscreenToggle() -> void:
	isFullscreen = !isFullscreen
	if isFullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func setMusicVolume(volume: float) -> void:
	SoundManager.set_music_volume(volume/100)


func setSFXVolume(volume: float) -> void:
	SoundManager.set_sound_volume(volume/100)


func _ready():
	# Capture the mouse (make it invisible)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Add command to toggle fullscreen
	Console.create_command("fullscreenToggle", self.fullscreenToggle, "toggle the window fullscreen mode.")

	# Add commands to set audio volume
	Console.create_command("setMusicVolume", self.setMusicVolume, "set the volume of music (0-100).")
	Console.create_command("setSFXVolume", self.setSFXVolume, "set the volume of sound effects (0-100).")

	# Start playing ambience track
	SoundManager.play_music(_ambSound, 1.0, "Music")
