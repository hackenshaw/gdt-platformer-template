class_name VirtualJoystick

extends Control

## A simple virtual joystick for touchscreens, with useful options.
## Github: https://github.com/MarcoFazioRandom/Virtual-Joystick-Godot

# EXPORTED VARIABLE

## The color of the button when the joystick is pressed.
@export var pressed_color := Color.GRAY

## If the input is inside this range, the output is zero.
@export_range(0, 200, 1) var deadzone_size : float = 10

## The max distance the tip can reach.
@export_range(0, 500, 1) var clampzone_size : float = 75

enum Joystick_mode {
	FIXED, ## The joystick doesn't move.
	DYNAMIC ## Every time the joystick area is pressed, the joystick position is set on the touched position.
}

## If the joystick stays in the same position or appears on the touched position when touch is started
@export var joystick_mode := Joystick_mode.FIXED

enum Visibility_mode {
	ALWAYS, ## Always visible
	TOUCHSCREEN_ONLY ## Visible on touch screens only
}

## If the joystick is always visible, or is shown only if there is a touchscreen
@export var visibility_mode := Visibility_mode.ALWAYS

## If true, the joystick uses Input Actions (Project -> Project Settings -> Input Map)
@export var use_input_actions := true

@export var action_left := "ui_left"
@export var action_right := "ui_right"
@export var action_up := "ui_up"
@export var action_down := "ui_down"

# PUBLIC VARIABLES

## If the joystick is receiving inputs.
var is_pressed := false

# The joystick output.
var output := Vector2.ZERO

# PRIVATE VARIABLES

var _touch_index : int = -1

@onready var _base := $Base
@onready var _tip := $Base/Tip

@onready var _base_radius = _base.size * _base.get_global_transform_with_canvas().get_scale() / 2

@onready var _base_default_position : Vector2 = _base.position
@onready var _tip_default_position : Vector2 = _tip.position

@onready var _default_color : Color = _tip.modulate

# FUNCTIONS

func _ready() -> void:
	if not DisplayServer.is_touchscreen_available() and visibility_mode == Visibility_mode.TOUCHSCREEN_ONLY:
		hide()

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			if _is_point_inside_joystick_area(event.position) and _touch_index == -1:
				if joystick_mode == Joystick_mode.DYNAMIC or (joystick_mode == Joystick_mode.FIXED and _is_point_inside_base(event.position)):
					if joystick_mode == Joystick_mode.DYNAMIC:
						_move_base(event.position)
					_touch_index = event.index
					_tip.modulate = pressed_color
					_update_joystick(event.position)
					get_viewport().set_input_as_handled()
		elif event.index == _touch_index:
			_reset()
			get_viewport().set_input_as_handled()
	elif event is InputEventScreenDrag:
		if event.index == _touch_index:
			_update_joystick(event.position)
			get_viewport().set_input_as_handled()

func _move_base(new_position: Vector2) -> void:
	_base.global_position = new_position - _base.pivot_offset * get_global_transform_with_canvas().get_scale()

func _move_tip(new_position: Vector2) -> void:
	_tip.global_position = new_position - _tip.pivot_offset * _base.get_global_transform_with_canvas().get_scale()

func _is_point_inside_joystick_area(point: Vector2) -> bool:
	var x: bool = point.x >= global_position.x and point.x <= global_position.x + (size.x * get_global_transform_with_canvas().get_scale().x)
	var y: bool = point.y >= global_position.y and point.y <= global_position.y + (size.y * get_global_transform_with_canvas().get_scale().y)
	return x and y

func _is_point_inside_base(point: Vector2) -> bool:
	var center : Vector2 = _base.global_position + _base_radius
	var vector : Vector2 = point - center
	if vector.length_squared() <= _base_radius.x * _base_radius.x:
		return true
	else:
		return false

func _update_joystick(touch_position: Vector2) -> void:
	var center : Vector2 = _base.global_position + _base_radius
	var vector : Vector2 = touch_position - center
	vector = vector.limit_length(clampzone_size)
	
	_move_tip(center + vector)
	
	if vector.length_squared() > deadzone_size * deadzone_size:
		is_pressed = true
		output = (vector - (vector.normalized() * deadzone_size)) / (clampzone_size - deadzone_size)
	else:
		is_pressed = false
		output = Vector2.ZERO
	
	if use_input_actions:
		_update_input_actions()

func _update_input_actions():
	if output.x < 0:
		Input.action_press(action_left, -output.x)
	elif Input.is_action_pressed(action_left):
		Input.action_release(action_left)
	if output.x > 0:
		Input.action_press(action_right, output.x)
	elif Input.is_action_pressed(action_right):
		Input.action_release(action_right)
	if output.y < 0:
		Input.action_press(action_up, -output.y)
	elif Input.is_action_pressed(action_up):
		Input.action_release(action_up)
	if output.y > 0:
		Input.action_press(action_down, output.y)
	elif Input.is_action_pressed(action_down):
		Input.action_release(action_down)

func _reset():
	is_pressed = false
	output = Vector2.ZERO
	_touch_index = -1
	_tip.modulate = _default_color
	_base.position = _base_default_position
	_tip.position = _tip_default_position
	if use_input_actions:
		if Input.is_action_pressed(action_left) or Input.is_action_just_pressed(action_left):
			Input.action_release(action_left)
		if Input.is_action_pressed(action_right) or Input.is_action_just_pressed(action_right):
			Input.action_release(action_right)
		if Input.is_action_pressed(action_down) or Input.is_action_just_pressed(action_down):
			Input.action_release(action_down)
		if Input.is_action_pressed(action_up) or Input.is_action_just_pressed(action_up):
			Input.action_release(action_up)
