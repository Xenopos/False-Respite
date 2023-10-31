extends Node
class_name enemyhealth


signal enemyhealthchanged
signal enemyrage(isenemyrage)
signal enemydeathtrigger
signal restorehealthready
signal applyknock


@export var menemymaxhealth: int = 500
var menemycurrenthealth : int = menemymaxhealth
var menemymaxpoise : int = 0
@export var maxdamagecounterforrestorehealth : int = 100
var currentdamagecounterforrestorehealth : int = maxdamagecounterforrestorehealth
var combocounter : int = 0
var ishedead : bool = false
var shizuka
var mainenem

func _ready():
	menemycurrenthealth = menemymaxhealth
	mainenem = get_tree().get_first_node_in_group("Enemy")
	shizuka = get_tree().get_first_node_in_group("Player")
	shizuka.connect("applydamagetoenemy", Callable(self, "take_damage"))
	ishedead = false 

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
		mainenem.enemyisdead()

func take_damage(amount: int):
	if not ishedead:
		applyknock.emit()
		push_warning("Enemy damage taken ", menemycurrenthealth)
		currentdamagecounterforrestorehealth -= amount
		if currentdamagecounterforrestorehealth <= 0 and not ishedead:
			restorehealthready.emit()
			currentdamagecounterforrestorehealth = maxdamagecounterforrestorehealth
		menemycurrenthealth = max(0, menemycurrenthealth - amount)
		enemy_check_health()
		enemyhealthchanged.emit()
	
func enemygoairborne():
	pass

