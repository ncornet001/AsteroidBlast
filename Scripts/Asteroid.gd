extends RigidBody3D

@export var speed = 50;
@export var life = 30;

@export var explosionPrefab = preload("res://Scenes/explosion.tscn")
@export var smallAsteroidPrefab = preload("res://Scenes/small_asteroid.tscn")
@onready var world = get_tree().get_current_scene() 

# Called when the node enters the scene tree for the first time.
func _ready():
	initialise();

func initialise():
	var dir = -transform.origin + Vector3(10*randf()-5,10*randf()-5,10*randf()-5)
	dir = dir.normalized()
	var rand_dir = Vector3(2*randf()-1,2*randf()-1,2*randf()-1)
	
	linear_velocity = dir * speed
	angular_velocity = rand_dir * 5

func _physics_process(delta):
	if(transform.origin.z > 0):
		get_tree().call_group("gamemanagers","loose")

func bullet_hit(damage):
	life -= damage
	if(life <= 0):
		var explosion = explosionPrefab.instantiate()
		world.add_child(explosion)
		explosion.transform.origin = transform.origin
		for i in range(6):
			var rand_dir = Vector3(2*randf()-1,2*randf()-1,2*randf()-1)
			rand_dir = rand_dir.normalized()
			var rock = smallAsteroidPrefab.instantiate()
			world.add_child(rock)
			rock.transform.origin = transform.origin
			rock.linear_velocity = rand_dir * 25
			rock.angular_velocity = Vector3(2*randf()-1,2*randf()-1,2*randf()-1)*10
		queue_free()
		get_tree().call_group("gamemanagers","add_score")
