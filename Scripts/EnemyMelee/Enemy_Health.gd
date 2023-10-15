extends Node

class_name enemyhealth
var menemymaxhealth :int = 100
var menemycurrenthealth : int 
#var menemymaxpoise : int = 0
#@export var healthbar : ProgressBar #= $Debug_healthbar/ProgressBar
@onready var healthtext : Label = $Debug_healthbar/Label


func _ready():
	menemycurrenthealth = menemymaxhealth
	
func _physics_process(_delta):
#	update_health_bar()
#	update_health_text()
	pass

func enemy_check_health():
	if menemycurrenthealth <= 0:
		enemy_death()

func enemy_death():
	push_warning("enemy death")

func take_damage(amount: int):
	menemycurrenthealth -= amount
	enemy_check_health()

#func update_health_bar():
#	healthbar.value = menemycurrenthealth

func update_health_text():
	healthtext.text = str(menemycurrenthealth)
