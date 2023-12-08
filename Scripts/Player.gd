extends Node3D

@onready var cam = $Camera
@onready var reticule = $Reticule
@onready var gun = $Gun
@onready var gunBarrel = $Gun/GunBarrel

@export var fireDelay = 0.3
var cooldown = 0

var bulletPrefab = preload("res://Scenes/bullet.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var res = raycast_from_mouse()
	if(not res.is_empty()):
		reticule.transform.origin = reticule.transform.origin.lerp(res.position,0.1)
		gun.look_at(reticule.transform.origin)

func _process(delta):
	cooldown -= delta
	
func _input(event):
	if (event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT):
		if(cooldown < 0):
			fire()
		

func fire():
	var b = bulletPrefab.instantiate()
	add_child(b)
	b.transform = gunBarrel.global_transform
	cooldown = fireDelay
	

func raycast_from_mouse():
	var m_pos = get_viewport().get_mouse_position()
	var ray_start = cam.project_ray_origin(m_pos)
	var ray_end = ray_start + cam.project_ray_normal(m_pos) * 1000
	var world3d : World3D = get_world_3d()
	var space_state = world3d.direct_space_state
	
	if space_state == null:
		return
	
	var query = PhysicsRayQueryParameters3D.create(ray_start, ray_end)
	query.collide_with_areas = true
	
	return space_state.intersect_ray(query)
  
