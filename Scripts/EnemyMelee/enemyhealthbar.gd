extends ProgressBar

var health : enemyhealth

func _ready():
	health = get_tree().get_first_node_in_group("enemyhealth")
	health.enemyhealthchanged.connect(updateene)
	updateene()
func updateene():
	if health.menemycurrenthealth == 0:
		self.visibility_layer = false
	value = health.menemycurrenthealth * 100 / 100
	
func _physics_process(_delta):
	value = health.menemycurrenthealth * 100 / 100
