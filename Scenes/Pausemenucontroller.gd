extends CanvasLayer
class_name pausemenu

signal continued

func _ready():
	pass
	
func _on_resume_pressed():
	continued.emit()
	$Pausemn.show()
func _on_quit_pressed():
	get_tree().quit()

func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().paused = false
