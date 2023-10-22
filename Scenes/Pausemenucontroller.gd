extends CanvasLayer
class_name pausemenu

signal continued

func _ready():
	pass
	
func _on_resume_pressed():
	continued.emit()

func _on_quit_pressed():
	get_tree().quit()
