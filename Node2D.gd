extends healthsys

@onready var healthtest : Label = $CanvasLayer/Label
@onready var healthtest2 : ProgressBar = $CanvasLayer/ProgressBar

func _ready():
	healthchanged.connect(update)
	update()

func _physics_process(_delta):
	pass

func update():
	healthtest2.value  = current_health * 100 / 100
	push_warning("called")
