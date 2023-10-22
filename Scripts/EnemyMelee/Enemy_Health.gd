extends Node
class_name enemyhealth


signal enemyhealthchanged
signal enemyrage(isenemyrage)
signal enemydeathtrigger
signal restorehealthready


@export var menemycurrenthealth : int = 100
var menemymaxpoise : int = 0
@export var maxdamagecounterforrestorehealth : int = 100
var currentdamagecounterforrestorehealth : int = maxdamagecounterforrestorehealth
var combocounter : int = 0

var ishedead : bool = false
func _ready():
	pass
			
func _physics_process(_delta):
	pass

func enemy_check_health():
	var twenty_percent_health = 0.2 * 500
	if menemycurrenthealth <= twenty_percent_health and not ishedead:
		enemyrage.emit(true)
		$"../SFX/rage".play()
	if menemycurrenthealth <= 0 and not ishedead:
		$"../SFX/rage2".play()
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

