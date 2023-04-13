extends Node

enum OS_TYPE { OTHER, WINDOWS, MACOS, LINUX, WEB, IOS, ANDROID }
enum OS_DEVICE { IPHONE, IPAD, PHONE, TABLET, OTHER}

var OSNAME : OS_TYPE = OS_TYPE.OTHER
var MODEL: OS_DEVICE = OS_DEVICE.OTHER


func _ready() -> void:
	#detect OS
	match OS.get_name():
		"Windows", "UWP":
			OSNAME = OS_TYPE.WINDOWS
		"macOS":
			OSNAME = OS_TYPE.MACOS
		"Linux", "FreeBSD", "NetBSD", "OpenBSD", "BSD":
			OSNAME = OS_TYPE.LINUX
		"Android":
			OSNAME = OS_TYPE.ANDROID
		"iOS":
			OSNAME = OS_TYPE.IOS
		"Web":
			OSNAME = OS_TYPE.WEB

	# if iOS, detect if iPhone or iPad
	if OSNAME == OS_TYPE.IOS:
		#TODO: assign value to MODEL
		print(OS.get_model_name())
			

		



