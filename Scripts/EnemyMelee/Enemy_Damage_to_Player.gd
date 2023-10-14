extends Node
class_name enemy_damage_to_player

@export var enemydamageamnt : int = 10
@export var enemypiercedamagemant: int = 20

var playerhealth = healthsys

func _ready():
	playerhealth = healthsys.new()

func _physics_process(_delta):
	pass
	
func enemynormalapplydamage():
	playerhealth.currenthealth -= enemydamageamnt

func enemypierceapplydamage():
	playerhealth.currenthealth -= enemypiercedamagemant
