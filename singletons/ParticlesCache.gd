extends CanvasLayer

const ALIEN_CORPSE_PX = preload("res://particles/alien_corpse_px.tres")
const BROOM_PX = preload("res://particles/broom_px.tres")
const BULLET_PX = preload("res://particles/bullet_px.tres")
const LASER_PX = preload("res://particles/laser_px.tres")
const WIND_PARTICLES = preload("res://particles/wind_particles.tres")

var materials = [
	ALIEN_CORPSE_PX,
	BROOM_PX,
	BULLET_PX, 
	LASER_PX,
	WIND_PARTICLES
]

var frames = 0
var loaded = false

func _ready() -> void:
	for material in materials:
		var particles_instance = GPUParticles2D.new()
		particles_instance.set_process_material(material)
		particles_instance.set_one_shot(true)
		particles_instance.set_modulate(Color(1, 1, 1, 0))
		particles_instance.set_emitting(true)
		self.add_child(particles_instance)

func _physics_process(delta: float) -> void:
	if frames >= 3:
		set_physics_process(false)
		loaded = true
	frames += 1
