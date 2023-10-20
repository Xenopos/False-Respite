extends Area2D

class_name skill2damagearea

signal applyskill2damage(canapplied2)

var enemyexitedrange2 : bool = true
func _ready():
	pass
func _physics_process(_delta):
	pass

func _on_body_entered(body):
	if body.name == "Melee_Enemy":
		var enemy_system = body.get_node("Enemy_Health")
		if (enemy_system):
			applyskill2damage.emit(true)
			push_warning("entered")
			enemyexitedrange2 = false

func _on_body_exited(body):
	if body.name == "Melee_Enemy":
		var enemy_system = body.get_node("Enemy_Health")
		if (enemy_system):
			push_warning("exited")
			applyskill2damage.emit(false)
			enemyexitedrange2 = true
