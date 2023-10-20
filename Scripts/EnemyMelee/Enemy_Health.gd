extends Node
class_name enemyhealth


signal enemyhealthchanged
signal enemyrage(isenemyrage)
signal enemydeathtrigger

var menemycurrenthealth : int = 100
var menemymaxpoise : int = 0

func _ready():
	pass
			
func _physics_process(_delta):
	pass

func enemy_check_health():
	if menemycurrenthealth <= 20 and menemycurrenthealth >= 20 :
		enemyrage.emit(true)
	if menemycurrenthealth == 0:
		enemydeathtrigger.emit()

func take_damage_skill1(amount: int):
	menemycurrenthealth -= amount

func take_damage(amount: int):
	push_warning("Enemy damage taken ", menemycurrenthealth)
	menemycurrenthealth -= amount
	enemy_check_health()
	enemyhealthchanged.emit()
	
func enemygoairborne():
	pass

