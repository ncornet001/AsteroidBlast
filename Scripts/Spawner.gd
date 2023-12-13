extends Node3D

var cooldown = 0
var delay = 2
var factor = 0.99
var speed = 30
var spawning = false

var asteroidPrefab = preload("res://Scenes/asteroid.tscn")

@onready var world = get_tree().get_root()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(spawning):
		cooldown -= delta
		if(cooldown <= 0):
			spawn()

func spawn():
	var a = asteroidPrefab.instantiate()
	world.add_child(a)
	delay = delay*factor
	if(delay < 0.8):
		delay = 1.75
		speed += 10
	cooldown = delay
	a.transform.origin.y = 100*randf() - 50
	a.transform.origin.x = 250*randf() - 125
	a.transform.origin.z = transform.origin.z
	a.speed = speed
	a.initialise()
	

func start():
	spawning = true

func restart():
	cooldown = 0
	delay = 2
	speed = 30
	var a = asteroidPrefab.instantiate()
	world.add_child(a)
	a.transform.origin.y = 70*randf() - 35
	a.transform.origin.x = 70*randf() - 35
	a.transform.origin.z = -100
	a.speed = 0
	a.linear_velocity = Vector3(0,0,0)
	var rand_dir = Vector3(2*randf()-1,2*randf()-1,2*randf()-1)
	a.angular_velocity = rand_dir * 5
	spawning = false

func loose():
	spawning = false
