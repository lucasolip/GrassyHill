extends Camera3D

@export var target : Node3D
@export var camera_sensitivity : float = 10.0
@export var max_vertical_angle : float = 20.0
@export var min_vertical_angle : float = -60.0
@export var max_zoom : float = 4.0
@export var min_zoom : float = 0.8
@export var rotating : bool = false
@export var rotation_speed : float = 0.1

var mouse_pressed = false
var initial_position : Vector3
var horizontal_angle = 0.0
var vertical_angle = 0.0
var distance = 2.0

func _ready():
	initial_position = position

func _process(delta):
	if rotating:
		horizontal_angle += rotation_speed
	initial_position = (initial_position - target.position).normalized() * distance
	position = initial_position.rotated(Vector3.UP, horizontal_angle)
	position = position.rotated(Vector3.RIGHT.rotated(Vector3.UP, horizontal_angle), vertical_angle)
	look_at(target.position)

func _input(event):
	if event is InputEventMouseButton:
		mouse_pressed = not mouse_pressed
	if event is InputEventMouseMotion and mouse_pressed:
		horizontal_angle -= camera_sensitivity * event.relative.x / get_viewport().size.x
		vertical_angle -= camera_sensitivity * event.relative.y / get_viewport().size.y
		if rad_to_deg(vertical_angle) > max_vertical_angle:
			vertical_angle = deg_to_rad(max_vertical_angle)
		if rad_to_deg(vertical_angle) < min_vertical_angle:
			vertical_angle = deg_to_rad(min_vertical_angle)
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			distance -= exp(0.5*distance-4)
			if distance <= min_zoom: distance = min_zoom
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			distance += exp(0.5*distance-4)
			if distance >= max_zoom: distance = max_zoom
