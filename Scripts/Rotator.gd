extends CSGBox3D

@export var rotation_axis = Vector3.UP
@export var rotation_speed = 3.14

# Called when the node enters the scene tree for the first time.
func _process(delta):
	rotate(rotation_axis,rotation_speed*delta)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
