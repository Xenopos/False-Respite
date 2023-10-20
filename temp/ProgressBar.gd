extends ProgressBar

var health : healthsys

func _ready():
	health = get_tree().get_first_node_in_group("shizukahealth")
	health.healthchanged.connect(update)
	update()
func update():
	value = health.current_health * 100 / 100
	
func _physics_process(_delta):
	value = health.current_health * 100 / 100
