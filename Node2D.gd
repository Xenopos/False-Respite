extends healthsys

@onready var healthtest : Label = $Label
@onready var healthtest2 : ProgressBar = $ProgressBar

func _ready():
	pass
func _on_health_changed():
	healthtest.text = str(current_health)
	healthtest2.value = current_health
	
func _physics_process(_delta):
	_on_health_changed()
