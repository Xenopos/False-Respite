class_name player_damage_to_enemy extends Node

@export var playerdamageamnt : int = 10
@export var playerskill1damagemant: int = 0
@export var playerskill2damagemant: int = 0
@export var playerskill3damagemant: int = 0

var Enemyhealth: enemyhealth

func _ready():
	Enemyhealth = enemyhealth.new()

func _physics_process(_delta):
	pass

func normalapplydamage():
	Enemyhealth.menemycurrenthealth -= playerdamageamnt

func skill1lapplydamage():
	Enemyhealth.menemycurrenthealth -= playerskill1damagemant

func skill2applydamage():
	Enemyhealth.menemycurrenthealth -= playerskill2damagemant

func skill3applydamage():
	Enemyhealth.menemycurrenthealth -= playerskill3damagemant
