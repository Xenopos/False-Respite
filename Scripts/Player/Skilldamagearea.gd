extends Area2D

class_name skill2damagearea

signal applyskill2damage(canapplied2)

var enemyexitedrange2 : bool = true
var mainenemy
func _ready():
	mainenemy = get_tree().get_first_node_in_group("Enemy")
func _physics_process(_delta):
	pass

func _on_body_entered(body):
	if body.name == "Melee_Enemy":
			applyskill2damage.emit(true)
			enemyexitedrange2 = false

func _on_body_exited(body):
	if body.name == "Melee_Enemy":
			applyskill2damage.emit(false)
			enemyexitedrange2 = true
