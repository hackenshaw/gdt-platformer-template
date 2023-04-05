extends ColorRect

func _ready() -> void:
	set_visible(false)
	Console.create_command("monitorToggle", self.showToggle, "show/hide the debug monitor overlay.")

func showToggle() -> void:
	set_visible(!visible)
