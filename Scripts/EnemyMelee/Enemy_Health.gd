extends Node
class_name enemyhealth

var menemymaxhealth :int = 100
var menemycurrenthealth : int = 100
var menemymaxpoise : int = 0
#@export var healthbar : ProgressBar #= $Debug_healthbar/ProgressBar
@onready var healthtext : Label = $Healthbar


func _ready():
	pass

	
func _physics_process(_delta):
	#	update_health_bar()
	pass
func enemy_check_health():
	if menemycurrenthealth <= 0:
		queue_free()

#func enemy_death():
#	push_warning("enemy death")

func take_damage(amount: int):
	menemycurrenthealth -= amount
	enemy_check_health()
	debughp()

#func update_health_bar():
#	healthbar.value = menemycurrenthealth

func debughp():
	push_warning("Current enemy health:", menemycurrenthealth)
	if healthtext:
		push_warning("called text to text enemy health:", menemycurrenthealth)
		healthtext.text = str(menemycurrenthealth)
	else:
		push_warning("healthtext is nil!")
