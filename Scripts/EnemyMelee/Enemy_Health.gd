extends Node

class_name enemyhealth
@export var menemymaxhealth :int = 100
@export var menemycurrenthealth : int = 100


func _ready():
	menemycurrenthealth = menemymaxhealth
	
func _physics_process(_delta):
	pass

func set_enemy_max_health():
	menemycurrenthealth = menemymaxhealth

func enemy_check_health():
	if menemycurrenthealth == 0:
		enemy_death()

func enemy_death():
	queue_free()
	push_warning("enemy death")

func enemyupdatehealth():
	menemycurrenthealth = menemymaxhealth

func take_damage(amount: int):
	menemycurrenthealth -= amount
	enemy_check_health()
