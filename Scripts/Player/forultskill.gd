class_name forult xtends Area2D

signal mightactivateult

func _ready():
	pass

func _on_body_entered(body):
	if body.has_node("Enemy_Health") and body.name == "Melee_Enemy":
		mightactivateult.emit()

func _on_body_exited(body):
	if body.has_node("Enemy_Health") and body.name == "Melee_Enemy":
		push_warning("Melee_Enemy with Enemy_Health node exited the area.")
