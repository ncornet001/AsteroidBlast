extends Node3D

@onready var part = $Particle
@onready var sound = $Sound

var lifetime = 8

var has_sparked = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	lifetime -= _delta
	if !has_sparked :
		part.emitting = true
		sound.playing = true
		has_sparked = true
	
	if(lifetime < 0):
		queue_free()

