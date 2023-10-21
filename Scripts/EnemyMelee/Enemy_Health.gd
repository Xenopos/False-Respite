extends Node
class_name enemyhealth


signal enemyhealthchanged
signal enemyrage(isenemyrage)
signal enemydeathtrigger
signal restorehealthready


var menemycurrenthealth : int = 100
var menemymaxpoise : int = 0
@export var maxdamagecounterforrestorehealth : int = 100
var currentdamagecounterforrestorehealth : int = maxdamagecounterforrestorehealth
var ishedead : bool = false
func _ready():
	pass
			
func _physics_process(_delta):
	pass

func enemy_check_health():
	if menemycurrenthealth <= 20 and menemycurrenthealth >= 20 and not ishedead:
		enemyrage.emit(true)
	if menemycurrenthealth == 0:
		ishedead = true
		enemydeathtrigger.emit()

func take_damage_skill1(amount: int):
	menemycurrenthealth -= amount

func take_damage(amount: int):
	push_warning("Enemy damage taken ", menemycurrenthealth)
	currentdamagecounterforrestorehealth -= amount
	if currentdamagecounterforrestorehealth <= 0 and not ishedead:
		restorehealthready.emit()
		currentdamagecounterforrestorehealth = maxdamagecounterforrestorehealth
	menemycurrenthealth = max(0, menemycurrenthealth - amount)
	if not ishedead:
		enemy_check_health()
	enemyhealthchanged.emit()
	
func enemygoairborne():
	pass

