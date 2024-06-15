extends StaticBody3D

var velocity : Vector3
@export var targets_parent : Node3D
var current_target
var steering_magnitude : float = 0.0005
var animation_player : AnimationPlayer
@export var speed = 10.0

func _ready():
	velocity = Vector3(0.1,0.0,0.0)
	animation_player = get_children()[1].get_children()[1]
	pick_target()
	
func _process(delta):
	var steer_force = steer_towards(current_target)
	look_at(velocity.normalized())
	velocity += steer_force
	velocity = velocity.normalized()*speed*delta
	position += velocity
	animation_player.speed_scale = remap(velocity.y*1000.0, -1.0, 10.0, 3.0, 5.0)
	
	if (position.distance_to(current_target) < 0.01):
		pick_target()
	
func pick_target():
	current_target = targets_parent.get_children().pick_random().position + Vector3.UP*0.2

func steer_towards(target):
	var desired = target - position
	var steer = desired - velocity
	steer = steer.normalized()*steering_magnitude
	return steer
	
#func avoid_floor():
	#var ray = RayCast3D.new()
	#add_child(ray)
#
	#ray.cast_to = velocity.normalized()*10.0
	#ray.from_position = position
#
	#if ray.is_colliding():
		#var desired = Vector3.UP
		#var steer = desired - velocity
		#print("COLLISION!")
		#return steer
	#return Vector3.ZERO
