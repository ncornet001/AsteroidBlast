extends Node3D

@export var damage = 120
@export var speed = 100
@export var lifetime = 2
@export var showtime = 0.03
@export var force = 300
#@export var explosion_prefab = preload("res://Prefabs/leaf_splash.tscn")
#@export var blood_prefab = preload("res://Prefabs/blood_splat.tscn")

#@onready var mesh = $Mesh
@onready var previouspos = transform.origin
@onready var world = get_tree().get_current_scene() 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#mesh.visible = 0

func collision():
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(previouspos,transform.origin,0b0001)
	var result = space_state.intersect_ray(query)
	if result:
		if result.collider != null:
			if(result.collider.has_method("bullet_hit")):
				result.collider.call("bullet_hit",damage)
				queue_free()
#				var explosion = blood_prefab.instantiate()
#				world.add_child(explosion)
#				explosion.transform.origin = result.position
#				get_tree().call_group("PhysObject","directional_explosion",force,2,result.position,-basis.z)
			else:
#				var explosion = explosion_prefab.instantiate()
#				world.add_child(explosion)
#				explosion.transform.origin = result.position
#				explosion.transform = explosion.transform.looking_at(-basis.z+explosion.transform.origin,Vector3.UP)
				queue_free()

func _physics_process(_delta):
	if showtime <= 0 && previouspos != Vector3.ZERO:
		collision()
	previouspos = transform.origin
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_translate(-basis.z*speed*delta)
	lifetime -= delta
	showtime -= delta
	if showtime <= 0:
		pass
		#mesh.visible = 1
	if lifetime <= 0:
		queue_free()
	

