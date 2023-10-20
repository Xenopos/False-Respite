extends TextureProgressBar


var health : healthsys
@onready var healthfxtimer : Timer = $healthfxtimer
func _ready():
	health = get_tree().get_first_node_in_group("shizukahealth")
	healthfxtimer.connect("timeout", Callable(self, "hitfxtimercd"))
	health.healthchanged.connect(update)
	update()

func update():
	value = health.current_health * 100 / 100
	self.material.set_shader_parameter("flash_modifier", 1)
	healthfxtimer.start(0.1)

func _physics_process(_delta):
	value = health.current_health * 100 / 100

func hitfxtimercd():
	self.material.set_shader_parameter("flash_modifier", 0)
