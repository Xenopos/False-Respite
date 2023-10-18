extends Area2D

class_name skill2damagearea

var shizuka : Shizuka
var playerdamagetoenemycntn: enemyhealth
var enemyexitedrange2 : bool = true

func _ready():
	shizuka = get_parent()
	playerdamagetoenemycntn = enemyhealth.new()

func _physics_process(_delta):
	applydamage()

func _on_body_entered(body):
	if body.name == "Melee_Enemy":
		var enemy_system = body.get_node("Enemy_Health")
		if (enemy_system):
			enemyexitedrange2 = false

func _on_body_exited(body):
	if body.name == "Melee_Enemy":
		var enemy_system = body.get_node("Enemy_Health")
		if (enemy_system):
			enemyexitedrange2 = true

func applydamage():
	if shizuka.skill2active and not enemyexitedrange2:
		playerdamagetoenemycntn.takecontinousdamage()
