extends Node3D

var cooldown = 0
var delay = 4
var factor = 0.98

var asteroidPrefab = preload("res://Scenes/asteroid.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cooldown -= delta
	if(cooldown <= 0):
		spawn()

func spawn():
	var a = asteroidPrefab.instantiate()
	add_child(a)
	delay = delay*factor
	if(delay < 0.3):
		delay = 2
	cooldown = delay
	a.transform.origin.y = 60*randf() - 30
	a.transform.origin.x = 60*randf() - 30
	
