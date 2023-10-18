extends Node
class_name enemyhealth


var menemycurrenthealth : int = 100
var menemymaxpoise : int = 0
var menemy : meleeenemy

func _ready():
	menemy = meleeenemy.new()
func _physics_process(_delta):
	pass

func enemy_check_health():
	if menemycurrenthealth <= 0:
		if menemy:
			menemy.enemyisdead()

func takecontinousdamage():
	pass

func take_damage_skill1(amount: int):
	menemycurrenthealth -= amount
	enemy_check_health()

func take_damage(amount: int):
	push_warning("Enemy damage taken ", menemycurrenthealth)
	menemycurrenthealth -= amount
	enemy_check_health()

func enemygoairborne():
	pass

