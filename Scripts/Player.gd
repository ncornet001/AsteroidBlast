extends Node3D

@onready var cam = $Camera
@onready var reticule = $Reticule
@onready var reticuleUI = $Control/Reticule
@onready var reticule2UI = $Control/Reticule2
@onready var gun = $Gun
@onready var gunBarrel1 = $Gun/GunBarrel
@onready var gunBarrel2 = $Gun/GunBarrel2
@onready var gunFlash1 = $Gun/GunBarrel/Fire
@onready var gunFlash2 = $Gun/GunBarrel2/Fire
@onready var fireSound = $Gun/FireSound
@onready var freeFireArea = $Gun/FreeFireZone
@onready var dangerZone = $DangerZone
@onready var dangerZoneSound = $DangerZone/AudioStreamPlayer
@onready var deadZoneSound = $DeadZone/AudioStreamPlayer
@onready var deadZone = $DeadZone
@onready var canon1 = $Gun/Canon2
@onready var canon2 = $Gun/Canon3
@onready var scoreCounter = $Control/Score
@onready var bestScoreCounter = $Control/BestScore
@onready var intro = $Control/Intro
@onready var lostscreen = $Control/Lost
@onready var whitescreen = $Control/Lost/WhiteSceen
@onready var restartsound = $RestartSound
var score = 0
var bestScore = 0

var shotFired = 0
@onready var canonOffset = canon1.transform.origin.z
@export var fireDelay = 0.1
@export var knockback = 0.2
var cooldown = 0
var knockback1 = 0
var knockback2 = 0

var bulletPrefab = preload("res://Scenes/bullet.tscn")

var lost = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var res = raycast_from_mouse()
	if(not res.is_empty()):
		reticule.transform.origin = reticule.transform.origin.lerp(res.position,0.1)
		gun.look_at(reticule.transform.origin)

func _process(delta):
	reticuleUI.rotation += delta*3
	reticuleUI.scale= Vector2(1+3*cooldown,1+3*cooldown)
	if(!lost && cooldown < 0):
		for body in freeFireArea.get_overlapping_bodies():
			if body.is_in_group("targets"):	
				fire()
				break
	else:
		cooldown -= delta
	if(knockback1 > 0):
		knockback1 -= delta
	if(knockback2 > 0):
		knockback2 -= delta
	canon1.transform.origin.z = canonOffset + knockback1
	canon2.transform.origin.z = canonOffset + knockback2
	
	if(dangerZone.has_overlapping_bodies()):
		if(!dangerZoneSound.playing):
			dangerZoneSound.playing = true
	else:
		dangerZoneSound.playing = false
			
	if(lost):
		if(cooldown <= 0):
			get_tree().call_group("gamemanagers","restart")
		if(cooldown <= 1):
			if(!restartsound.playing && cooldown <= 0.5):
				restartsound.playing = true
			whitescreen.color.a = 1-cooldown
		
	

func fire():
	fireSound.play()
	var b = bulletPrefab.instantiate()
	add_child(b)
	
	cooldown = fireDelay
	if(shotFired % 2 == 0):
		b.transform = gunBarrel1.global_transform
		knockback1 = knockback
		gunFlash1.restart()
		gunFlash1.emitting = true
	else:
		b.transform = gunBarrel2.global_transform
		knockback2 = knockback
		gunFlash2.restart()
		gunFlash2.emitting = true
	shotFired += 1
	

func raycast_from_mouse():
	var m_pos = get_viewport().get_mouse_position()
	reticuleUI.position = reticuleUI.position.lerp(m_pos - Vector2(40,40),0.1)
	reticule2UI.position = m_pos - Vector2(20,20)
	
	var ray_start = cam.project_ray_origin(m_pos)
	var ray_end = ray_start + cam.project_ray_normal(m_pos) * 1000
	var world3d : World3D = get_world_3d()
	var space_state = world3d.direct_space_state
	
	if space_state == null:
		return
	
	var query = PhysicsRayQueryParameters3D.create(ray_start, ray_end,0b011)
	query.collide_with_areas = true
	
	return space_state.intersect_ray(query)
  
func add_score():
	score += 1
	scoreCounter.text = str(score)
	if(score == 1):
		get_tree().call_group("gamemanagers","start")
	
func start():
	intro.visible = false
	
func loose():
	if(!deadZoneSound.playing):
		deadZoneSound.playing = true
	whitescreen.color.a = 0
	lostscreen.visible = true
	lost = true
	gun.visible = false
	cooldown = 6
	get_tree().call_group("targets","queue_free")
	
	if(score >= bestScore):
		bestScore = score
		bestScoreCounter.text = str(score)
	
func restart():
	lostscreen.visible = false
	scoreCounter.text = "Best Score:"
	gun.visible = true
	gunFlash1.restart()
	gunFlash2.restart()
	lost = false
	score = 0
	
	
