extends Label

var health : healthsys

func _ready():
	health = get_tree().get_first_node_in_group("shizukahealth")
	
func update():
	pass
	
func _physics_process(_delta):
	text = str("Health ", health.current_health * 100 / 100, " / 100")
