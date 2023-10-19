extends ProgressBar

@export var health : healthsys

func _ready():
	health.healthchanged.connect(update)
	update()
func update():
	value = health.current_health * 100 / 100
