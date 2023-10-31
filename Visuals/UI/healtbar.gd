extends TextureProgressBar

var health : healthsys
@onready var healthfxtimer : Timer = $healthfxtimer
@onready var shake_timer : Timer = Timer.new()  # Timer to control shake duration
var original_position: Vector2
var shaking = false

func _ready():
	health = get_tree().get_first_node_in_group("shizukahealth")
	
	# Setting up the health flash effect timer
	healthfxtimer.connect("timeout", Callable(self, "hitfxtimercd"))
	health.healthchanged.connect(update)
	
	# Setting up the shake effect timer
	original_position = position
	shake_timer.set_wait_time(0.05)
	shake_timer.connect("timeout", Callable(self, "_shake"))
	add_child(shake_timer)
	
	update()

func update():
	self.material.set_shader_parameter("flash_modifier", 1)
	healthfxtimer.start(0.1)

	# Start shake effect
	shaking = true
	shake_timer.start()

func _physics_process(_delta):
	value = health.current_health * 100 / 100

	if shaking:
		position = original_position + Vector2(randf_range(-10, 10), randf_range(-10, 10))

func hitfxtimercd():
	self.material.set_shader_parameter("flash_modifier", 0)

func _shake():
	shaking = false
	position = original_position
