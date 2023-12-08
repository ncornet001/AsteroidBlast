extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	initialise();

func initialise():
	linear_velocity.z = 25;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func bullet_hit(damage):
	queue_free()
