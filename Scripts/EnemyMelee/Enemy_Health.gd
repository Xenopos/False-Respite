extends Node
class_name enemyhealth

var menemycurrenthealth : int = 100
var menemymaxpoise : int = 0
#@export var healthtext : Label 
var menemy : meleeenemy

func _ready():
	menemy = meleeenemy.new()

func _physics_process(_delta):
	#	update_health_bar()
	pass

func enemy_check_health():
	if menemycurrenthealth <= 0:
		queue_free()

func takecontinousdamage():
	pass

#func enemy_death():
#	push_warning("enemy death")

func take_damage(amount: int):
	push_warning("Enemy damage taken ", menemycurrenthealth)
	menemycurrenthealth -= amount
	enemy_check_health()
#	debughp()

func enemygoairborne():
	pass

